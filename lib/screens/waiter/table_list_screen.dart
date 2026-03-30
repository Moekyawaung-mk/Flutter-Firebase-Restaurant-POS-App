```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../providers/auth_provider.dart';
import '../../services/table_service.dart';
import 'order_screen.dart';

class TableListScreen extends StatelessWidget {
  const TableListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    final t = AppLanguage.t;

    return Scaffold(
      appBar: AppBar(title: Text(t('tables'))),
      body: StreamBuilder(
        stream: TableService().getTables(user.restaurantId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tables = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tables.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final table = tables[index];
              Color color = Colors.green;
              if (table.status == 'occupied') color = Colors.orange;
              if (table.status == 'billing') color = Colors.red;

              return GestureDetector(
                onTap: () {
                  context.read<CartProvider>().clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderScreen(table: table),
                    ),
                  );
                },
                child: Card(
                  color: color,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          table.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

