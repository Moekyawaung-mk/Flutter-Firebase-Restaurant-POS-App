```dart
class MenuItemModel {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final int price;
  final bool available;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.available,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map, String id) {
    return MenuItemModel(
      id: id,
      restaurantId: map['restaurantId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      available: map['available'] ?? true,
    );
  }
}
```
