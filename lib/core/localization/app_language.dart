```dart
import 'en_strings.dart';
import 'mm_strings.dart';

class AppLanguage {
  static String current = 'mm';

  static Map<String, String> get strings =>
      current == 'en' ? enStrings : mmStrings;

  static String t(String key) => strings[key] ?? key;
}
```
