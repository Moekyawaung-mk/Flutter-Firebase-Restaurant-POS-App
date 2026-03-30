```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../common/home_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final ok = await context.read<AuthProvider>().login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeRouter()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<AuthProvider>().errorMessage ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final t = AppLanguage.t;

    return Scaffold(
      appBar: AppBar(title: Text(t('staff_login'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Code: ${auth.restaurantCode}'),
            const SizedBox(height: 16),
            AppTextField(controller: emailController, label: t('email')),
            const SizedBox(height: 12),
            AppTextField(
              controller: passwordController,
              label: t('password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: t('login'),
              loading: auth.isLoading,
              onPressed: login,
            ),
          ],
        ),
      ),
    );
  }
}
```
