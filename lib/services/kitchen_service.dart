```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class KitchenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getKitchenOrders(String restaurantId) {
    return _db
        .collection('orders')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('status', whereIn: ['new', 'preparing', 'ready'])
        .orderBy('createdAt')
        .snapshots()
        .asyncMap((ordersSnapshot) async {
      List<Map<String, dynamic>> orders = [];

      for (final order in ordersSnapshot.docs) {
        final items = await _db
            .collection('order_items')
            .where('restaurantId', isEqualTo: restaurantId)
            .where('orderId', isEqualTo: order.id)
            .get();

        orders.add({
          'orderId': order.id,
          'tableId': order['tableId'],
          'status': order['status'],
          'items': items.docs.map((e) => {'id': e.id, ...e.data()}).toList(),
        });
      }
      return orders;
    });
  }

  Future<void> updateOrderItemStatus({
    required String restaurantId,
    required String orderId,
    required String itemId,
    required String status,
  }) async {
    await _db.collection('order_items').doc(itemId).update({'status': status});
    await _refreshOrderStatus(restaurantId: restaurantId, orderId: orderId);
  }

  Future<void> _refreshOrderStatus({
    required String restaurantId,
    required String orderId,
  }) async {
    final items = await _db
        .collection('order_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('orderId', isEqualTo: orderId)
        .get();

    final statuses = items.docs.map((e) => e['status'] as String).toList();

    String orderStatus = 'new';
    if (statuses.isNotEmpty && statuses.every((s) => s == 'ready')) {
      orderStatus = 'ready';
    } else if (statuses.any((s) => s == 'preparing' || s == 'ready')) {
      orderStatus = 'preparing';
    }

    await _db.collection('orders').doc(orderId).update({
      'status': orderStatus,
    });
  }
}
```
