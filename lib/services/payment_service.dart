```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<void> makePayment({
    required String restaurantId,
    required String orderId,
    required String tableId,
    required int subtotal,
    required int discount,
    required int taxAmount,
    required int grandTotal,
    required String method,
  }) async {
    final batch = _db.batch();

    batch.set(_db.collection('payments').doc(_uuid.v4()), {
      'restaurantId': restaurantId,
      'orderId': orderId,
      'subtotal': subtotal,
      'discount': discount,
      'taxAmount': taxAmount,
      'grandTotal': grandTotal,
      'method': method,
      'paidAt': FieldValue.serverTimestamp(),
    });

    batch.update(_db.collection('orders').doc(orderId), {
      'status': 'paid',
      'subtotal': subtotal,
      'discount': discount,
      'taxAmount': taxAmount,
      'grandTotal': grandTotal,
    });

    batch.update(_db.collection('tables').doc(tableId), {
      'status': 'empty',
    });

    await batch.commit();
  }
}
```
