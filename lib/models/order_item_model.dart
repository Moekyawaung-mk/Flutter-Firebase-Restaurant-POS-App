```dart
class OrderItemModel {
  final String id;
  final String orderId;
  final String itemId;
  final String name;
  final int qty;
  final int price;
  final String note;
  final String status;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.itemId,
    required this.name,
    required this.qty,
    required this.price,
    required this.note,
    required this.status,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderItemModel(
      id: id,
      orderId: map['orderId'] ?? '',
      itemId: map['itemId'] ?? '',
      name: map['name'] ?? '',
      qty: map['qty'] ?? 1,
      price: map['price'] ?? 0,
      note: map['note'] ?? '',
      status: map['status'] ?? 'new',
    );
  }
}
```
