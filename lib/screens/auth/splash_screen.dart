```dart
import 'package:flutter/material.dart';
import 'restaurant_code_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RestaurantCodeScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text(
          'Restaurant POS MM',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
```
