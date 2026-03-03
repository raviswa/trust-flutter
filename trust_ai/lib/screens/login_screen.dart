// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus  = FocusNode();

  bool    _showPass = false;
  String? _emailErr;
  String? _passErr;

  @override
  void dispose() {
    _emailCtrl.dispose(); _passCtrl.dispose();
    _emailFocus.dispose(); _passFocus.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _emailErr = RegExp(r'^[^@]+@[^@]+\.[^@]+$')
              .hasMatch(_emailCtrl.text.trim())
          ? null
          : 'Please enter a valid email address.';
      _passErr = _passCtrl.text.length >= 6
          ? null
          : 'Password must be at least 6 characters.';
    });
    return _emailErr == null && _passErr == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login({
      'email':    _emailCtrl.text.trim(),
      'password': _passCtrl.text,
    });
    if (ok && mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ───────────────────────────────────────────────
          _TopBar(onBack: () => context.pop()),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: AutofillGroup(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Welcome back 👋', style: T.h2),
                  const SizedBox(height: 6),
                  Text('Sign in to continue your recovery journey',
                      style: T.bodySmall),
                  const SizedBox(height: 24),

                  // Error banner
                  ErrorBanner(message: auth.error),
                  if (auth.error != null) const SizedBox(height: 14),

                  // Email
                  AppFormField(
                    label: 'Email Address',
                    hint: 'Please enter your email',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailCtrl,
                    focus: _emailFocus,
                    errorText: _emailErr,
                    keyboard: TextInputType.emailAddress,
                    autofill: AutofillHints.email,
                    onSubmit: () => _passFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppFormField(
                    label: 'Password',
                    hint: 'Please enter your password',
                    icon: Icons.lock_outline_rounded,
                    controller: _passCtrl,
                    focus: _passFocus,
                    errorText: _passErr,
                    obscure: !_showPass,
                    autofill: AutofillHints.password,
                    action: TextInputAction.done,
                    onSubmit: _submit,
                    suffix: IconButton(
                      icon: Icon(
                        _showPass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: C.muted, size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _showPass = !_showPass),
                    ),
                  ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot password?',
                          style: T.label.copyWith(color: C.navy)),
                    ),
                  ),

                  PrimaryBtn(
                      label: 'Sign In',
                      loading: auth.loading,
                      onTap: _submit),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Row(children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or continue with',
                            style: T.bodySmall),
                      ),
                      const Expanded(child: Divider()),
                    ]),
                  ),

                  // Social
                  Row(children: [
                    Expanded(
                      child: SocialBtn(
                          label: 'Google',
                          icon: Icons.g_mobiledata_rounded,
                          onTap: () {}),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SocialBtn(
                          label: 'Apple',
                          icon: Icons.apple_rounded,
                          onTap: () {}),
                    ),
                  ]),

                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push('/register'),
                      child: RichText(
                        text: TextSpan(
                          style: T.bodySmall,
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: T.label.copyWith(color: C.navy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Shared top-bar widget used by login + each intake step ───────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: onBack,
          ),
          Row(children: [
            Image.asset('assets/logo.png', width: 28, height: 28),
            const SizedBox(width: 8),
            Text('TRUST AI',
                style: T.label.copyWith(letterSpacing: 0.5)),
          ]),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
