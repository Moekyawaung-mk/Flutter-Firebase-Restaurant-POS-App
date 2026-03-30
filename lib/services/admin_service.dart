```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/staff_create_request.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createStaffProfileOnly({
    required String uid,
    required StaffCreateRequest request,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': request.name,
      'email': request.email,
      'role': request.role,
      'restaurantId': request.restaurantId,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
```
