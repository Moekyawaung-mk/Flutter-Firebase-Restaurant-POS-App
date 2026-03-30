```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import 'login_screen.dart';

class RestaurantCodeScreen extends StatefulWidget {
  const RestaurantCodeScreen({super.key});

  @override
  State<RestaurantCodeScreen> createState() => _RestaurantCodeScreenState();
}

class _RestaurantCodeScreenState extends State<RestaurantCodeScreen> {
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLanguage.t;
    final language = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t('restaurant_code')),
        actions: [
          PopupMenuButton<String>(
            onSelected: language.setLanguage,
            itemBuilder: (_) => [
              PopupMenuItem(value: 'mm', child: Text(t('myanmar'))),
              PopupMenuItem(value: 'en', child: Text(t('english'))),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(
              controller: codeController,
              label: t('enter_restaurant_code'),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: t('continue'),
              onPressed: () {
                context.read<AuthProvider>().setRestaurantCode(codeController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```
