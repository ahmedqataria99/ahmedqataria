import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hive/hive.dart';
import '../models/item.dart';
import '../models/daily_transaction.dart';
import '../services/db_service.dart';
import '../models/action_log.dart';

// مزود إدارة المخزون: تحميل العناصر، حساب المجموعات، وتسجيل المعاملات اليومية
class InventoryProvider extends ChangeNotifier {
  List<Item> items = [];

  InventoryProvider() {
    _loadItems();
  }

  void _loadItems() {
    final box = Hive.box<Item>(DbService.itemsBox);
    items = box.values.toList();
    notifyListeners();
  }

  Future<void> addItem(
    Item item, {
    String actor = 'system',
    String role = 'system',
  }) async {
    await DbService.addItem(item);
    // سجل الإجراء
    final log = ActionLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actor: actor,
      role: role,
      action: 'add_item',
      details: 'item: ${item.name}',
      timestamp: DateTime.now().toIso8601String(),
    );
    await DbService.addLog(log);
    _loadItems();
  }

  Future<void> updateItem(
    Item item, {
    String actor = 'system',
    String role = 'system',
  }) async {
    await DbService.updateItem(item);
    final log = ActionLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actor: actor,
      role: role,
      action: 'update_item',
      details: 'item: ${item.name}',
      timestamp: DateTime.now().toIso8601String(),
    );
    await DbService.addLog(log);
    _loadItems();
  }

  Future<void> deleteItem(
    String id, {
    String actor = 'system',
    String role = 'system',
  }) async {
    final box = Hive.box<Item>(DbService.itemsBox);
    final it = box.get(id);
    await DbService.deleteItem(id);
    final log = ActionLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actor: actor,
      role: role,
      action: 'delete_item',
      details: 'item: ${it?.name ?? id}',
      timestamp: DateTime.now().toIso8601String(),
    );
    await DbService.addLog(log);
    _loadItems();
  }

  // تعديل الكمية (زيادة أو نقصان)
  Future<void> adjustQuantity(
    String id,
    int delta, {
    String actor = 'system',
    String role = 'system',
  }) async {
    final box = Hive.box<Item>(DbService.itemsBox);
    final it = box.get(id);
    if (it != null) {
      it.quantity = it.quantity + delta;
      await box.put(id, it);
      final log = ActionLog(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        actor: actor,
        role: role,
        action: 'adjust_quantity',
        details: 'item: ${it.name}, delta: $delta',
        timestamp: DateTime.now().toIso8601String(),
      );
      await DbService.addLog(log);
      _loadItems();
    }
  }

  // تسجيل انخفاضات اليوم: يقوم بتخزين المعاملة ويخفض الكميات
  Future<void> recordDailyDecrements(
    String date,
    Map<String, int> decrements, {
    String actor = 'system',
    String role = 'system',
  }) async {
    final box = Hive.box<Item>(DbService.itemsBox);
    final prev = <String, int>{};
    // حفظ الكميات السابقة ثم تطبيق التخفيض
    decrements.forEach((id, dec) {
      final it = box.get(id);
      if (it != null) {
        prev[id] = it.quantity;
        // استخدم math.max لتجنب قيمة عددية كبيرة لا يمكن تمثيلها في JS
        it.quantity = math.max(0, it.quantity - dec);
        box.put(id, it);
      }
    });

    final tx = DailyTransaction(
      date: date,
      decrements: decrements,
      prevQuantities: prev,
    );
    await DbService.saveTransaction(tx);
    // سجل الإجراء
    final log = ActionLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actor: actor,
      role: role,
      action: 'daily_decrement',
      details: 'decrements: ${decrements.length} items',
      timestamp: DateTime.now().toIso8601String(),
    );
    await DbService.addLog(log);
    _loadItems();
  }

  // تراجع عن المعاملة لليوم: يعيد الكميات كما كانت
  Future<void> undoDailyTransaction(
    String date, {
    String actor = 'system',
    String role = 'system',
  }) async {
    final tx = DbService.getTransactionForDate(date);
    if (tx == null) return;
    final box = Hive.box<Item>(DbService.itemsBox);
    tx.prevQuantities.forEach((id, prevQty) {
      final it = box.get(id);
      if (it != null) {
        it.quantity = prevQty;
        box.put(id, it);
      }
    });
    await DbService.deleteTransaction(date);
    final log = ActionLog(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actor: actor,
      role: role,
      action: 'undo_daily',
      details: 'undo for $date',
      timestamp: DateTime.now().toIso8601String(),
    );
    await DbService.addLog(log);
    _loadItems();
  }

  // احصاءات حسب الفئة
  Map<String, int> categoryTotals() {
    final map = <String, int>{};
    for (var it in items) {
      map[it.category] = (map[it.category] ?? 0) + it.quantity;
    }
    return map;
  }

  // تنبيهات انخفاض المخزون
  List<Item> lowStockAlerts() {
    return items.where((e) => e.quantity <= e.lowThreshold).toList();
  }
}
