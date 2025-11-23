import 'dart:io';

// كاتب ملف لسطح المكتب/الـ non-web
Future<String> writeFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
  return file.path;
}
