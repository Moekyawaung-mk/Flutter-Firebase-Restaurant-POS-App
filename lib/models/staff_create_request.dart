```dart
class StaffCreateRequest {
  final String name;
  final String email;
  final String password;
  final String role;
  final String restaurantId;

  StaffCreateRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.restaurantId,
  });
}
```
