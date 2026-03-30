```dart
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String languageCode = 'mm';

  void setLanguage(String code) {
    languageCode = code;
    notifyListeners();
  }
}
```
