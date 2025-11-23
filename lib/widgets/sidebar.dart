import 'package:flutter/material.dart';
import '../theme.dart';

// Simple desktop sidebar with role-based navigation
class Sidebar extends StatelessWidget {
  final String role;
  final void Function(String) onNavigate;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.role,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: ThemeColors.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Inventory',
                  style: TextStyle(color: Color(0xFFB8860B), fontSize: 20),
                ),
                Text(
                  'Inventory Management',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Color(0xFFB8860B)),
            title: const Text('Summary'),
            onTap: () => onNavigate('summary'),
          ),
          ListTile(
            leading: const Icon(Icons.today, color: Color(0xFFB8860B)),
            title: const Text('Daily Entry'),
            onTap: () => onNavigate('daily'),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFFB8860B)),
            title: const Text('Activity Log'),
            onTap: () => onNavigate('activity'),
          ),
          if (role == 'admin')
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFB8860B)),
              title: const Text('Manage Items'),
              onTap: () => onNavigate('admin'),
            ),
          ListTile(
            leading: const Icon(Icons.tune, color: Color(0xFFB8860B)),
            title: const Text('Settings'),
            onTap: () => onNavigate('settings'),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
