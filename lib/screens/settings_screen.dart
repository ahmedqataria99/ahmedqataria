import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../theme.dart';

// Settings screen: general options and export
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _lastExportPath = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 20, color: ThemeColors.gold),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.gold),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final path = await DbService.exportCsv();
            if (!mounted) return;
            setState(() => _lastExportPath = path);
            messenger.showSnackBar(const SnackBar(content: Text('Exported')));
          },
          child: const Text('Export CSV'),
        ),
        const SizedBox(height: 8),
        if (_lastExportPath.isNotEmpty) Text('Export file: $_lastExportPath'),
      ],
    );
  }
}
