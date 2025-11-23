import 'package:hive/hive.dart';

// نموذج سجل الإجراءات (من أي مستخدم)
@HiveType(typeId: 3)
class ActionLog {
  @HiveField(0)
  String id;

  @HiveField(1)
  String actor; // اسم المستخدم الذي قام بالفعل

  @HiveField(2)
  String role; // دور المستخدم عند القيام بالفعل

  @HiveField(3)
  String action; // وصف الإجراء مثل 'add_item', 'delete_item', 'adjust_quantity', 'daily_decrement', 'undo'

  @HiveField(4)
  String details; // تفاصيل قابلة للعرض (مثلاً اسم الصنف، كمية، ...)

  @HiveField(5)
  String timestamp; // ISO

  ActionLog({
    required this.id,
    required this.actor,
    required this.role,
    required this.action,
    required this.details,
    required this.timestamp,
  });
}

class ActionLogAdapter extends TypeAdapter<ActionLog> {
  @override
  final int typeId = 3;

  @override
  ActionLog read(BinaryReader reader) {
    final id = reader.readString();
    final actor = reader.readString();
    final role = reader.readString();
    final action = reader.readString();
    final details = reader.readString();
    final timestamp = reader.readString();
    return ActionLog(
      id: id,
      actor: actor,
      role: role,
      action: action,
      details: details,
      timestamp: timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, ActionLog obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.actor);
    writer.writeString(obj.role);
    writer.writeString(obj.action);
    writer.writeString(obj.details);
    writer.writeString(obj.timestamp);
  }
}
