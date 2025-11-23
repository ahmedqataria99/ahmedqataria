import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/db_service.dart';
import 'providers/auth_provider.dart';
import 'providers/inventory_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/activity_screen.dart';
import 'theme.dart';

// ملفات الدخول الرئيسية للتطبيق
// هذا الملف يقوم بتهيئة قاعدة البيانات المحلية، تسجيل الموفرين، وتعيين السمات والتوجيهات.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService.init(); // تهيئة Hive وفتح الصناديق

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      child: MaterialApp(
        title: 'Shop Inventory',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: ThemeColors.background,
          colorScheme: ColorScheme.dark(
            primary: ThemeColors.gold,
            secondary: ThemeColors.gold,
          ),
          textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: ThemeColors.text,
            displayColor: ThemeColors.text,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: ThemeColors.background,
            elevation: 1,
            foregroundColor: ThemeColors.gold,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppButtonStyles.goldElevated,
          ),
          textButtonTheme: TextButtonThemeData(style: AppButtonStyles.goldText),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: ThemeColors.gold,
              foregroundColor: Colors.white,
              side: const BorderSide(color: ThemeColors.gold),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/activity': (context) => const ActivityScreen(),
        },
      ),
    );
  }
}
