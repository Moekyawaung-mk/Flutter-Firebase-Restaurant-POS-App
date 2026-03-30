```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/localization/app_language.dart';
import '../screens/auth/splash_screen.dart';
import 'theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    AppLanguage.current = lang.languageCode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant POS MM',
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
```

