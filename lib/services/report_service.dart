```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getTodaySales(String restaurantId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _db
        .collection('payments')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('paidAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('paidAt', isLessThan: Timestamp.fromDate(end))
        .get();

    int totalSales = 0;
    for (final doc in snapshot.docs) {
      totalSales += (doc.data()['grandTotal'] ?? 0) as int;
    }

    return {
      'totalSales': totalSales,
      'totalOrders': snapshot.docs.length,
    };
  }
}
```
