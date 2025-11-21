import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email to receive reset instructions'),
            const SizedBox(height: 12),
            PrimaryTextField(controller: emailCtrl, label: 'Email'),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Send link',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Reset link sent (mock)')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
