import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';
import '../main/main_shell_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthController authController;
  const RegisterScreen({super.key, required this.authController});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  double strength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PrimaryTextField(controller: nameCtrl, label: 'Name'),
              const SizedBox(height: 12),
              PrimaryTextField(
                controller: emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => widget.authController.validateEmail(value ?? '') ? null : 'Invalid email',
              ),
              const SizedBox(height: 12),
              PrimaryTextField(
                controller: passCtrl,
                label: 'Password',
                obscure: true,
                validator: (value) => (value?.length ?? 0) >= 8 ? null : 'Min 8 chars',
                onChanged: (value) => setState(() => strength = _scorePassword(value ?? '')),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: strength, minHeight: 8),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_strengthLabel(), style: Theme.of(context).textTheme.bodySmall)),
              const SizedBox(height: 12),
              PrimaryTextField(
                controller: confirmCtrl,
                label: 'Confirm password',
                obscure: true,
                validator: (value) => value == passCtrl.text ? null : 'Passwords do not match',
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Sign up',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await widget.authController.login(emailCtrl.text, passCtrl.text);
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainShellScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _scorePassword(String value) {
    double score = 0;
    if (value.length >= 8) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) score += 0.25;
    if (RegExp(r'[0-9]').hasMatch(value)) score += 0.25;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score += 0.25;
    return score.clamp(0, 1);
  }

  String _strengthLabel() {
    if (strength < 0.4) return 'Weak';
    if (strength < 0.7) return 'Medium';
    return 'Strong';
  }
}
