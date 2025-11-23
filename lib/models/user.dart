import 'package:hive/hive.dart';

// نموذج مستخدم لتخزين الحسابات محلياً
@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password; // تبسيط: كلمة مرور نصية محلية (غير مشفرة)

  @HiveField(2)
  String role; // 'admin' أو 'user'

  User({required this.username, required this.password, required this.role});
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final username = reader.readString();
    final password = reader.readString();
    final role = reader.readString();
    return User(username: username, password: password, role: role);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.username);
    writer.writeString(obj.password);
    writer.writeString(obj.role);
  }
}
