import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../models/action_log.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';
import 'activity_detail_screen.dart';

// Activity log screen: shows actions performed by admins and users
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<ActionLog> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);
    final logs = DbService.getAllLogs();
    if (!mounted) return;
    setState(() {
      _logs = logs; // getAllLogs returns newest-first
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
            color: ThemeColors.gold,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (() {
              // determine which logs to show: admins see all, regular users see only their own
              final all = _logs;
              final List<ActionLog> showLogs;
              if (auth.currentUser?.role == 'admin') {
                showLogs = all;
              } else {
                final username = auth.currentUser?.username ?? '';
                showLogs = all.where((e) => e.actor == username).toList();
              }

              if (showLogs.isEmpty) {
                return const Center(child: Text('No logs yet'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, i) {
                  final l = showLogs[i];
                  final isMine = auth.currentUser?.username == l.actor;
                  return ListTile(
                    tileColor: ThemeColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isMine
                          ? ThemeColors.gold
                          : Colors.grey[800],
                      child: Text(
                        l.actor.isNotEmpty ? l.actor[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      '${l.actor}  •  ${l.role}',
                      style: AppTextStyles.title,
                    ),
                    subtitle: Text(
                      '${l.action}\n${l.details}',
                      style: AppTextStyles.subtitle,
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      _formatTs(l.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ActivityDetailScreen(log: l),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: showLogs.length,
              );
            }()),
    );
  }
  // details are now shown in a dedicated screen (ActivityDetailScreen)

  String _formatTs(String ts) {
    try {
      final d = DateTime.parse(ts);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return ts;
    }
  }
}
