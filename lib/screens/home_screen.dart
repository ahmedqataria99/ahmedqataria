import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/admin_item_manage.dart';
import '../screens/daily_entry.dart';
import '../screens/inventory_summary.dart';
import '../screens/settings_screen.dart';
import '../screens/activity_screen.dart';
import '../widgets/sidebar.dart';

// شاشة المنزل الرئيسية: واجهة سطح مكتب مع شريط جانبي
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _route = 'summary';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final role = auth.currentUser?.role ?? 'user';

    Widget content;
    switch (_route) {
      case 'admin':
        content = const AdminItemManage();
        break;
      case 'daily':
        content = const DailyEntryScreen();
        break;
      case 'settings':
        content = const SettingsScreen();
        break;
      case 'activity':
        content = const ActivityScreen();
        break;
      case 'summary':
      default:
        content = const InventorySummaryScreen();
        break;
    }

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            role: role,
            onNavigate: (r) => setState(() => _route = r),
            onLogout: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(12), child: content),
          ),
        ],
      ),
    );
  }
}
