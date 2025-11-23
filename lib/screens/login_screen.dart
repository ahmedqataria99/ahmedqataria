import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';

// Simple login screen with username and password
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.gold),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 26,
                  color: ThemeColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _userCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),

              // main sign-in button uses GoldButton for consistent look + decorative shape
              const SizedBox(height: 6),

              ElevatedButton(
                onPressed: () async {
                  final auth = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final ok = await auth.login(
                    _userCtrl.text.trim(),
                    _passCtrl.text,
                  );
                  if (!mounted) return; // تحقق من أن الـ State ما زال موجودًا
                  if (ok) {
                    navigator.pushReplacementNamed('/home');
                  } else {
                    setState(() {
                      _error = 'Invalid credentials';
                    });
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.gold,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_error, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
