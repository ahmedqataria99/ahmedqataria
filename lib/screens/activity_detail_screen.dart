import 'package:flutter/material.dart';
import '../models/action_log.dart';
import '../theme.dart';

class ActivityDetailScreen extends StatelessWidget {
  final ActionLog log;
  const ActivityDetailScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
        backgroundColor: ThemeColors.background,
        foregroundColor: ThemeColors.gold,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Actor', style: AppTextStyles.header),
              const SizedBox(height: 6),
              Text(log.actor, style: AppTextStyles.title),
              const SizedBox(height: 12),

              Text('Role', style: AppTextStyles.header),
              const SizedBox(height: 6),
              Text(log.role, style: AppTextStyles.title),
              const SizedBox(height: 12),

              Text('Action', style: AppTextStyles.header),
              const SizedBox(height: 6),
              Text(log.action, style: AppTextStyles.title),
              const SizedBox(height: 12),

              Text('Details', style: AppTextStyles.header),
              const SizedBox(height: 6),
              SelectableText(log.details, style: AppTextStyles.subtitle),
              const SizedBox(height: 12),

              Text('Timestamp', style: AppTextStyles.header),
              const SizedBox(height: 6),
              Text(log.timestamp, style: AppTextStyles.subtitle),
              const SizedBox(height: 12),

              Text('Log ID', style: AppTextStyles.header),
              const SizedBox(height: 6),
              Text(log.id, style: const TextStyle(color: Colors.white60)),

              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    style: AppButtonStyles.goldElevated,
                    onPressed: () {
                      // copy details to clipboard
                      // Note: Clipboard uses services; importing here would be trivial but avoid for now
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
