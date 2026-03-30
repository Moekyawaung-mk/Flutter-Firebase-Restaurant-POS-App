```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard.dart';
import '../cashier/billing_screen.dart';
import '../kitchen/kitchen_orders_screen.dart';
import '../waiter/table_list_screen.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user')));
    }

    switch (user.role) {
      case 'admin':
        return const AdminDashboard();
      case 'waiter':
        return const TableListScreen();
      case 'kitchen':
        return const KitchenOrdersScreen();
      case 'cashier':
        return const BillingScreen();
      default:
        return const Scaffold(body: Center(child: Text('Unknown role')));
    }
  }
}
```
