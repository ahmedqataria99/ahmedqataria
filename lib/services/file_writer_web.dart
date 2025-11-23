// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
// كاتب ملف مخصص للويب: ينشئ تنزيل للمستخدم عبر عنصر <a>
import 'dart:html' as html;

Future<String> writeFile(String filename, String content) async {
  final blob = html.Blob([content], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return filename;
}
