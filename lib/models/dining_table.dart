```dart
class DiningTable {
  final String id;
  final String restaurantId;
  final String name;
  final String status;

  DiningTable({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.status,
  });

  factory DiningTable.fromMap(Map<String, dynamic> map, String id) {
    return DiningTable(
      id: id,
      restaurantId: map['restaurantId'] ?? '',
      name: map['name'] ?? '',
      status: map['status'] ?? 'empty',
    );
  }
}
```
