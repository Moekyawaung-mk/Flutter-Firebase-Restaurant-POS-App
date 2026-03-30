```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/order_item_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createOrder({
    required String restaurantId,
    required String tableId,
    required String createdBy,
    required List<OrderItemModel> items,
  }) async {
    final orderId = _uuid.v4();

    int total = 0;
    for (final item in items) {
      total += item.price * item.qty;
    }

    final batch = _db.batch();

    batch.set(_db.collection('orders').doc(orderId), {
      'restaurantId': restaurantId,
      'tableId': tableId,
      'status': 'new',
      'createdBy': createdBy,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    });

    for (final item in items) {
      batch.set(_db.collection('order_items').doc(_uuid.v4()), {
        'restaurantId': restaurantId,
        'orderId': orderId,
        'itemId': item.itemId,
        'name': item.name,
        'qty': item.qty,
        'price': item.price,
        'note': item.note,
        'status': 'new',
      });
    }

    batch.update(_db.collection('tables').doc(tableId), {
      'status': 'occupied',
    });

    await batch.commit();
    return orderId;
  }

  Stream<List<Map<String, dynamic>>> getOpenOrders(String restaurantId) {
    return _db
        .collection('orders')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('status', whereIn: ['new', 'preparing', 'ready'])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => {'id': e.id, ...e.data()}).toList());
  }

  Future<List<Map<String, dynamic>>> getOrderItems(String restaurantId, String orderId) async {
    final snapshot = await _db
        .collection('order_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('orderId', isEqualTo: orderId)
        .get();

    return snapshot.docs.map((e) => {'id': e.id, ...e.data()}).toList();
  }
}
```
