import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../models/user.dart';
import '../models/daily_transaction.dart';
import '../models/action_log.dart';
import 'package:csv/csv.dart';
// استيراد مشروط لكاتب الملفات (ويب vs غير ويب)
import 'file_writer_nonweb.dart'
    if (dart.library.html) 'file_writer_web.dart'
    as file_writer;

// خدمة قاعدة البيانات المحلية: تهيئة Hive وتوفير واجهات CRUD أساسية
class DbService {
  static const String itemsBox = 'items';
  static const String usersBox = 'users';
  static const String txBox = 'transactions';
  static const String settingsBox = 'settings';

  // تهيئة Hive وفتح الصناديق
  static Future<void> init() async {
    // تهيئة Hive بطريقة متوافقة مع الويب وسطح المكتب
    // على الويب لا نستخدم مسارات ملفات نظام التشغيل
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    } else {
      await Hive.initFlutter();
    }

    // تسجيل المحولات
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(DailyTransactionAdapter());
    Hive.registerAdapter(ActionLogAdapter());

    await Hive.openBox<Item>(itemsBox);
    await Hive.openBox<User>(usersBox);
    await Hive.openBox<DailyTransaction>(txBox);
    await Hive.openBox<ActionLog>('logs');
    await Hive.openBox(settingsBox);

    // تهيئة حسابات افتراضية إن لم توجد
    final users = Hive.box<User>(usersBox);
    // إذا كانت الصندوق فارغًا، نُنشئ حسابات افتراضية
    if (users.isEmpty) {
      users.put(
        'admin',
        User(username: 'admin', password: 'admin', role: 'admin'),
      );
      users.put('user', User(username: 'user', password: 'user', role: 'user'));
    }

    // تأكد من وجود حساب الأدمن الذي طلبته 'omar'
    if (!users.containsKey('omar')) {
      users.put(
        'omar',
        User(username: 'omar', password: 'omar11', role: 'admin'),
      );
    } else {
      // في حال رغبت بتحديث كلمة المرور أو الدور يمكن فعل ذلك هنا
      final existing = users.get('omar');
      if (existing != null) {
        existing.password = 'omar11';
        existing.role = 'admin';
        users.put('omar', existing);
      }
    }
  }

  // تسجيل سجل إجراء
  static Future<void> addLog(ActionLog log) async {
    final box = Hive.box<ActionLog>('logs');
    await box.put(log.id, log);
  }

  // استرجاع السجلات (جميعها)
  static List<ActionLog> getAllLogs() {
    final box = Hive.box<ActionLog>('logs');
    return box.values.toList().reversed.toList(); // آخرها أولاً
  }

  // إضافة عنصر
  static Future<void> addItem(Item item) async {
    final box = Hive.box<Item>(itemsBox);
    await box.put(item.id, item);
  }

  // تحديث عنصر
  static Future<void> updateItem(Item item) async {
    final box = Hive.box<Item>(itemsBox);
    await box.put(item.id, item);
  }

  // حذف عنصر
  static Future<void> deleteItem(String id) async {
    final box = Hive.box<Item>(itemsBox);
    await box.delete(id);
  }

  // إضافة أو تحديث معاملة يومية
  static Future<void> saveTransaction(DailyTransaction tx) async {
    final box = Hive.box<DailyTransaction>(txBox);
    await box.put(tx.date, tx);
  }

  // الحصول على المعاملة لليوم
  static DailyTransaction? getTransactionForDate(String date) {
    final box = Hive.box<DailyTransaction>(txBox);
    return box.get(date);
  }

  // حذف معاملة (التراجع)
  static Future<void> deleteTransaction(String date) async {
    final box = Hive.box<DailyTransaction>(txBox);
    await box.delete(date);
  }

  // تصدير كل السجلات إلى CSV
  static Future<String> exportCsv() async {
    final items = Hive.box<Item>(itemsBox).values.toList();
    final List<List<dynamic>> rows = [];
    rows.add(['id', 'name', 'category', 'quantity', 'lowThreshold']);
    for (var it in items) {
      rows.add([it.id, it.name, it.category, it.quantity, it.lowThreshold]);
    }

    // توليد CSV
    final csvString = const ListToCsvConverter().convert(rows);

    // على الويب نقوم ببدء تنزيل؛ على النظم الأخرى نكتب ملفًا في مجلد المستندات
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          'inventory_export_${DateTime.now().toIso8601String()}.csv';
      final fullPath = '${dir.path}/$filename';
      // use platform-specific writer
      await file_writer.writeFile(fullPath, csvString);
      return fullPath;
    } else {
      final filename =
          'inventory_export_${DateTime.now().toIso8601String()}.csv';
      await file_writer.writeFile(filename, csvString);
      return filename;
    }
  }

  // Export action logs to CSV
  static Future<String> exportLogsCsv() async {
    final logs = Hive.box<ActionLog>('logs').values.toList();
    final List<List<dynamic>> rows = [];
    rows.add(['id', 'actor', 'role', 'action', 'details', 'timestamp']);
    for (var l in logs) {
      rows.add([l.id, l.actor, l.role, l.action, l.details, l.timestamp]);
    }

    final csvString = const ListToCsvConverter().convert(rows);

    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          'activity_export_${DateTime.now().toIso8601String()}.csv';
      final fullPath = '${dir.path}/$filename';
      await file_writer.writeFile(fullPath, csvString);
      return fullPath;
    } else {
      final filename =
          'activity_export_${DateTime.now().toIso8601String()}.csv';
      await file_writer.writeFile(filename, csvString);
      return filename;
    }
  }
}
