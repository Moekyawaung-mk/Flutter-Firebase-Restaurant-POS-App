```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/staff_create_request.dart';
import '../../providers/auth_provider.dart';
import '../../services/admin_service.dart';

class CreateStaffScreen extends StatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
  final uidController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'waiter';
  bool loading = false;

  Future<void> submit() async {
    final user = context.read<AuthProvider>().currentUser!;
    setState(() => loading = true);

    try {
      final request = StaffCreateRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: role,
        restaurantId: user.restaurantId,
      );

      await AdminService().createStaffProfileOnly(
        uid: uidController.text.trim(),
        request: request,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff profile created')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: uidController,
              decoration: const InputDecoration(labelText: 'Firebase Auth UID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'waiter', child: Text('Waiter')),
                DropdownMenuItem(value: 'kitchen', child: Text('Kitchen')),
                DropdownMenuItem(value: 'cashier', child: Text('Cashier')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => role = value);
              },
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Create Staff'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: Firebase Auth user must be created first. This screen creates Firestore profile only.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
```
