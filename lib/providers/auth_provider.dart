```dart
import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? currentUser;
  String restaurantCode = '';
  bool isLoading = false;
  String? errorMessage;

  void setRestaurantCode(String code) {
    restaurantCode = code.trim().toUpperCase();
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await _authService.loginWithRestaurantCode(
        email: email,
        password: password,
        restaurantCode: restaurantCode,
      );

      isLoading = false;
      notifyListeners();
      return currentUser != null;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    restaurantCode = '';
    notifyListeners();
  }
}
```
