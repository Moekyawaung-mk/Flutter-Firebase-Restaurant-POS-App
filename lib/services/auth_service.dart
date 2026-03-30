```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> loginWithRestaurantCode({
    required String email,
    required String password,
    required String restaurantCode,
  }) async {
    final restQuery = await _db
        .collection('restaurants')
        .where('code', isEqualTo: restaurantCode.toUpperCase())
        .limit(1)
        .get();

    if (restQuery.docs.isEmpty) {
      throw Exception('Invalid restaurant code');
    }

    final restaurantId = restQuery.docs.first.id;

    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final userDoc = await _db.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      throw Exception('User profile not found');
    }

    final data = userDoc.data()!;
    if (data['restaurantId'] != restaurantId) {
      throw Exception('This account is not for this restaurant');
    }
    if (data['active'] != true) {
      throw Exception('User is inactive');
    }

    return AppUser.fromMap(data, uid);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
```
