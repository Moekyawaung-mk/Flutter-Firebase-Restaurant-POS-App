```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../providers/auth_provider.dart';
import '../auth/restaurant_code_screen.dart';
import 'create_staff_screen.dart';
import 'daily_sales_report_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguage.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('admin_dashboard')),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RestaurantCodeScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateStaffScreen()),
                );
              },
              child: Text(t('create_staff')),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailySalesReportScreen()),
                );
              },
              child: Text(t('daily_sales_report')),
            ),
          ],
        ),
      ),
    );
  }
}
```
