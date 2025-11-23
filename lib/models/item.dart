import 'package:hive/hive.dart';

// نموذج عنصر المخزون
@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String id; // معرف فريد

  @HiveField(1)
  String name; // اسم الصنف

  @HiveField(2)
  String category; // "Hot Drinks", "Cold Drinks", "Snacks"

  @HiveField(3)
  int quantity; // الكمية الحالية

  @HiveField(4)
  int lowThreshold; // حد التنبيه عند انخفاض المخزون

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.lowThreshold = 5,
  });
}

// مبدّل يدوي (TypeAdapter) لتفادي الحاجة لـ build_runner
class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final category = reader.readString();
    final quantity = reader.readInt();
    final lowThreshold = reader.readInt();
    return Item(
      id: id,
      name: name,
      category: category,
      quantity: quantity,
      lowThreshold: lowThreshold,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.category);
    writer.writeInt(obj.quantity);
    writer.writeInt(obj.lowThreshold);
  }
}
