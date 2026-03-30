```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/report_service.dart';

class DailySalesReportScreen extends StatefulWidget {
  const DailySalesReportScreen({super.key});

  @override
  State<DailySalesReportScreen> createState() => _DailySalesReportScreenState();
}

class _DailySalesReportScreenState extends State<DailySalesReportScreen> {
  bool loading = true;
  Map<String, dynamic>? data;

  Future<void> load() async {
    final user = context.read<AuthProvider>().currentUser!;
    final result = await ReportService().getTodaySales(user.restaurantId);
    setState(() {
      data = result;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Sales Report'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Total Sales Today'),
                      trailing: Text('${data?['totalSales'] ?? 0} MMK'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Total Paid Orders'),
                      trailing: Text('${data?['totalOrders'] ?? 0}'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
```
