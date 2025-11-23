import 'package:flutter/material.dart';
import '../models/item.dart';

// Simple tile to display an inventory item
class ItemTile extends StatelessWidget {
  final Item item;
  final List<Widget>? actions;

  const ItemTile({super.key, required this.item, this.actions});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('${item.category} • Qty: ${item.quantity}'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: actions ?? []),
    );
  }
}
