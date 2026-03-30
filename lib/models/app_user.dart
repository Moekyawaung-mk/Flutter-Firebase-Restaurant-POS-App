```dart
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String restaurantId;
  final bool active;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.restaurantId,
    required this.active,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      active: map['active'] ?? false,
    );
  }
}
```
