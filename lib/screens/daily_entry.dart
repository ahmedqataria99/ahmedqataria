import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/auth_provider.dart';
import '../models/item.dart';
import '../theme.dart';

// Daily entry screen for users to record sold/consumed amounts
class DailyEntryScreen extends StatefulWidget {
  const DailyEntryScreen({super.key});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};
  String _dateStr = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateStr =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InventoryProvider>(context);

    for (var it in prov.items) {
      _controllers.putIfAbsent(it.id, () => TextEditingController(text: '0'));
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Entry ($_dateStr)',
          style: const TextStyle(fontSize: 20, color: ThemeColors.gold),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: prov.items.length,
            itemBuilder: (_, idx) {
              final Item it = prov.items[idx];
              return ListTile(
                title: Text(it.name),
                subtitle: Text(
                  'Remaining: ${it.quantity} • Category: ${it.category}',
                ),
                trailing: SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _controllers[it.id],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Decrease'),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.gold,
              ),
              onPressed: () async {
                final map = <String, int>{};
                _controllers.forEach((id, ctrl) {
                  final v = int.tryParse(ctrl.text) ?? 0;
                  if (v != 0) map[id] = v;
                });
                if (map.isEmpty) return;
                final messenger = ScaffoldMessenger.of(context);
                await prov.recordDailyDecrements(
                  _dateStr,
                  map,
                  actor: auth.currentUser?.username ?? 'unknown',
                  role: auth.currentUser?.role ?? 'user',
                );
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Entries saved')),
                );
              },
              child: const Text('Save'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await prov.undoDailyTransaction(
                  _dateStr,
                  actor: auth.currentUser?.username ?? 'unknown',
                  role: auth.currentUser?.role ?? 'user',
                );
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Daily entries undone')),
                );
              },
              child: const Text('Undo'),
            ),
          ],
        ),
      ],
    );
  }
}
