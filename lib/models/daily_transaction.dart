import 'package:hive/hive.dart';

// تخزين معاملة يومية: خفض الكميات لليوم
@HiveType(typeId: 2)
class DailyTransaction {
  @HiveField(0)
  String date; // YYYY-MM-DD

  @HiveField(1)
  Map<String, int> decrements; // itemId -> units decreased

  @HiveField(2)
  Map<String, int> prevQuantities; // لاسترجاع الكميات عند التراجع

  DailyTransaction({
    required this.date,
    required this.decrements,
    required this.prevQuantities,
  });
}

class DailyTransactionAdapter extends TypeAdapter<DailyTransaction> {
  @override
  final int typeId = 2;

  @override
  DailyTransaction read(BinaryReader reader) {
    final date = reader.readString();
    final decrements = Map<String, int>.from(reader.readMap());
    final prev = Map<String, int>.from(reader.readMap());
    return DailyTransaction(
      date: date,
      decrements: decrements,
      prevQuantities: prev,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTransaction obj) {
    writer.writeString(obj.date);
    writer.writeMap(obj.decrements);
    writer.writeMap(obj.prevQuantities);
  }
}
