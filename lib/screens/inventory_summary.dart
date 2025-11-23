import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../theme.dart';

// Inventory summary: shows current quantities, totals per category, and low-stock alerts
class InventorySummaryScreen extends StatelessWidget {
  const InventorySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InventoryProvider>(context);
    final totals = prov.categoryTotals();
    final lows = prov.lowStockAlerts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventory Summary',
          style: TextStyle(fontSize: 20, color: ThemeColors.gold),
        ),
        const SizedBox(height: 12),
        Card(
          color: ThemeColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: totals.entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key,
                            style: const TextStyle(color: ThemeColors.gold),
                          ),
                          Text('Remaining: ${e.value}'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Low Stock Alerts',
          style: TextStyle(color: ThemeColors.gold),
        ),
        if (lows.isEmpty)
          const Text('No alerts')
        else
          Expanded(
            child: ListView.builder(
              itemCount: lows.length,
              itemBuilder: (_, i) {
                final it = lows[i];
                return ListTile(
                  title: Text(it.name),
                  subtitle: Text('Qty: ${it.quantity}'),
                );
              },
            ),
          ),
      ],
    );
  }
}
