import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/item.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';

// Item management screen for admin: add, edit, delete, adjust quantity
class AdminItemManage extends StatefulWidget {
  const AdminItemManage({super.key});

  @override
  State<AdminItemManage> createState() => _AdminItemManageState();
}

class _AdminItemManageState extends State<AdminItemManage> {
  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '0');
    String category = 'Hot Drinks';
    final lowCtrl = TextEditingController(text: '5');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(
                    value: 'Hot Drinks',
                    child: Text('Hot Drinks'),
                  ),
                  DropdownMenuItem(
                    value: 'Cold Drinks',
                    child: Text('Cold Drinks'),
                  ),
                  DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                ],
                onChanged: (v) => category = v ?? category,
              ),
              TextField(
                controller: lowCtrl,
                decoration: const InputDecoration(labelText: 'Low threshold'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.gold,
              ),
              onPressed: () async {
                final prov = Provider.of<InventoryProvider>(
                  context,
                  listen: false,
                );
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final navigator = Navigator.of(context);
                final it = Item(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: nameCtrl.text.trim(),
                  category: category,
                  quantity: int.tryParse(qtyCtrl.text) ?? 0,
                  lowThreshold: int.tryParse(lowCtrl.text) ?? 5,
                );
                await prov.addItem(
                  it,
                  actor: auth.currentUser?.username ?? 'unknown',
                  role: auth.currentUser?.role ?? 'user',
                );
                if (!mounted) return;
                navigator.pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InventoryProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Manage Items',
              style: TextStyle(fontSize: 20, color: ThemeColors.gold),
            ),
            ElevatedButton(
              onPressed: _showAddDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.gold,
              ),
              child: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: prov.items.length,
            itemBuilder: (_, idx) {
              final it = prov.items[idx];
              return ListTile(
                title: Text(it.name),
                subtitle: Text('${it.category} • Qty: ${it.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final auth = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        await prov.deleteItem(
                          it.id,
                          actor: auth.currentUser?.username ?? 'unknown',
                          role: auth.currentUser?.role ?? 'user',
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        // quick adjust
                        showDialog(
                          context: context,
                          builder: (_) {
                            final deltaCtrl = TextEditingController(text: '0');
                            return AlertDialog(
                              title: const Text('Adjust Quantity (neg or pos)'),
                              content: TextField(
                                controller: deltaCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Delta',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.gold,
                                  ),
                                  onPressed: () async {
                                    final delta =
                                        int.tryParse(deltaCtrl.text) ?? 0;
                                    final auth = Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    );
                                    final navigator = Navigator.of(context);
                                    await prov.adjustQuantity(
                                      it.id,
                                      delta,
                                      actor:
                                          auth.currentUser?.username ??
                                          'unknown',
                                      role: auth.currentUser?.role ?? 'user',
                                    );
                                    if (!mounted) return;
                                    navigator.pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit, color: ThemeColors.gold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
