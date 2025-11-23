import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../services/db_service.dart';

// مزود المصادقة: تسجيل الدخول والخروج وحالة المستخدم الحالي
class AuthProvider extends ChangeNotifier {
  User? currentUser;

  // محاولة تسجيل الدخول بمطابقة اسم المستخدم والكلمة
  Future<bool> login(String username, String password) async {
    final box = Hive.box<User>(DbService.usersBox);
    final user = box.get(username);
    if (user != null && user.password == password) {
      currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
