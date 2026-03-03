// lib/screens/register_screen.dart
//
// Dart equivalent of trustai-app/screens/RegisterScreen.js
// Same fields, same validation, same API call (/api/auth/register)
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/auth_provider.dart';
import '../data/static_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers — mirrors the form state in RN
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  // Focus nodes for keyboard "next" chain
  final _nameFocus  = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus  = FocusNode();

  String? _country;
  String? _language;
  bool    _showPass = false;

  // Validation errors
  String? _nameErr, _emailErr, _phoneErr,
          _countryErr, _langErr, _passErr;

  @override
  void dispose() {
    _nameCtrl.dispose();  _emailCtrl.dispose();
    _phoneCtrl.dispose(); _passCtrl.dispose();
    _nameFocus.dispose(); _emailFocus.dispose();
    _phoneFocus.dispose(); _passFocus.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _nameErr    = _nameCtrl.text.trim().isEmpty
          ? 'Please enter your name.' : null;
      _emailErr   = RegExp(r'^[^@]+@[^@]+\.[^@]+$')
              .hasMatch(_emailCtrl.text.trim())
          ? null : 'Please enter a valid email.';
      _phoneErr   = _phoneCtrl.text.trim().length >= 7
          ? null : 'Please enter a valid phone number.';
      _countryErr = _country == null ? 'Please select your country.' : null;
      _langErr    = _language == null ? 'Please select a language.' : null;
      _passErr    = _passCtrl.text.length >= 6
          ? null : 'Password must be at least 6 characters.';
    });
    return [_nameErr, _emailErr, _phoneErr,
            _countryErr, _langErr, _passErr].every((e) => e == null);
  }

  Future<void> _continue() async {
    if (!_validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register({
      'name':              _nameCtrl.text.trim(),
      'email':             _emailCtrl.text.trim(),
      'phone':             _phoneCtrl.text.trim(),
      'country':           _country,
      'preferredLanguage': _language,
      'password':          _passCtrl.text,
    });
    if (ok && mounted) context.push('/intake/feelings');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const StepProgressBar(step: 1, total: 5),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: AutofillGroup(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Let's get to know you", style: T.h2),
                  const SizedBox(height: 24),

                  ErrorBanner(message: auth.error),
                  if (auth.error != null) const SizedBox(height: 14),

                  // ── Name ────────────────────────────────────────────
                  AppFormField(
                    label: 'Name',
                    hint: 'Please enter your name',
                    icon: Icons.person_outline_rounded,
                    controller: _nameCtrl,
                    focus: _nameFocus,
                    errorText: _nameErr,
                    autofill: AutofillHints.name,
                    autocapWords: true,
                    onSubmit: () => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // ── Email ────────────────────────────────────────────
                  AppFormField(
                    label: 'Email',
                    hint: 'Please enter your email',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailCtrl,
                    focus: _emailFocus,
                    errorText: _emailErr,
                    keyboard: TextInputType.emailAddress,
                    autofill: AutofillHints.email,
                    onSubmit: () => _phoneFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // ── Phone ────────────────────────────────────────────
                  AppFormField(
                    label: 'Phone',
                    hint: 'Please enter your phone number',
                    icon: Icons.phone_outlined,
                    controller: _phoneCtrl,
                    focus: _phoneFocus,
                    errorText: _phoneErr,
                    keyboard: TextInputType.phone,
                    autofill: AutofillHints.telephoneNumber,
                    action: TextInputAction.done,
                    onSubmit: () {},
                  ),
                  const SizedBox(height: 16),

                  // ── Country ──────────────────────────────────────────
                  AppDropdownField(
                    label: 'Select your country',
                    hint: 'Select your country',
                    icon: Icons.language_rounded,
                    value: _country,
                    errorText: _countryErr,
                    onTap: () => showPickerSheet(
                      context: context,
                      title: 'Select Country',
                      items: kCountries,
                      onSelect: (v) => setState(() {
                        _country = v;
                        _countryErr = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Language ─────────────────────────────────────────
                  AppDropdownField(
                    label: 'Preferred Language',
                    hint: 'Select your language',
                    icon: Icons.translate_rounded,
                    value: _language,
                    errorText: _langErr,
                    onTap: () => showPickerSheet(
                      context: context,
                      title: 'Select Language',
                      items: kLanguages,
                      onSelect: (v) => setState(() {
                        _language = v;
                        _langErr = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Password ─────────────────────────────────────────
                  AppFormField(
                    label: 'Password',
                    hint: 'Please enter your password',
                    icon: Icons.lock_outline_rounded,
                    controller: _passCtrl,
                    focus: _passFocus,
                    errorText: _passErr,
                    obscure: !_showPass,
                    autofill: AutofillHints.newPassword,
                    action: TextInputAction.done,
                    onSubmit: _continue,
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
                  const SizedBox(height: 28),

                  PrimaryBtn(
                    label: 'Continue',
                    arrow: true,
                    loading: auth.loading,
                    onTap: _continue,
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
