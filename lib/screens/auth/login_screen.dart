import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../controllers/auth_controller.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_text_field.dart';
import '../main/main_shell_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  const LoginScreen({super.key, required this.authController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool hidePassword = true;
  bool invalid = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('login'), style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                PrimaryTextField(
                  controller: emailCtrl,
                  label: t.t('email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value != null && widget.authController.validateEmail(value) ? null : 'Invalid email',
                ),
                const SizedBox(height: 12),
                PrimaryTextField(
                  controller: passCtrl,
                  label: t.t('password'),
                  obscure: hidePassword,
                  validator: (value) =>
                      value != null && widget.authController.validatePassword(value) ? null : 'Min 8 chars',
                  suffix: IconButton(
                    icon: Icon(hidePassword ? IconlyLight.hide : IconlyLight.show),
                    onPressed: () => setState(() => hidePassword = !hidePassword),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                    ),
                    child: Text(t.t('forgot_password')),
                  ),
                ),
                if (invalid)
                  Text(
                    'Invalid credentials',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                const SizedBox(height: 12),
                PrimaryButton(label: t.t('login'), onPressed: _handleLogin),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    await widget.authController.continueAsGuest();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainShellScreen()),
                    );
                  },
                  child: Text(t.t('guest')),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(onPressed: () {}, icon: const Icon(IconlyLight.login), label: const Text('Google')),
                    const SizedBox(width: 8),
                    TextButton.icon(onPressed: () {}, icon: const Icon(IconlyLight.login), label: const Text('Apple')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t.t('register') + '? '),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegisterScreen(authController: widget.authController)),
                      ),
                      child: Text(t.t('register')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => invalid = true);
      return;
    }
    final ok = await widget.authController.login(emailCtrl.text, passCtrl.text);
    if (!ok) {
      setState(() => invalid = true);
      return;
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
    );
  }
}
