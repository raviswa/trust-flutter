// lib/screens/privacy_screen.dart
//
// Dart equivalent of trustai-app/screens/PrivacyScreen.js
// Calls POST /api/intake/consent  →  navigates to /dashboard
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _State();
}

class _State extends State<PrivacyScreen> {
  // Default checked — matches the HTML
  bool    _consented = true;
  bool    _loading   = false;
  String? _error;

  Future<void> _complete() async {
    if (!_consented) {
      setState(() => _error = 'You must consent to continue using Trust AI.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiService.i.submitConsent();
      // navigation.reset({ index:0, routes:[{name:'Dashboard'}] })
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() => _error = ApiService.parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const ClinicalHeader(),
          const StepProgressBar(step: 5, total: 5),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: IntakeCard(
                child: Column(children: [

                  // ── Shield icon ──────────────────────────────────
                  Container(
                    width: 56, height: 56,
                    decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                    child: const Icon(Icons.shield_rounded,
                        size: 28, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(height: 14),

                  Text('Privacy & Data Sharing', style: T.h3,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('Your data is encrypted and HIPAA-compliant',
                      style: T.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: 20),

                  // ── Data-use info box ────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: C.navyBg,
                      border: Border.all(color: C.navyBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 16, color: C.navy),
                        const SizedBox(width: 8),
                        Text('TRUST AI uses your data to',
                            style: T.label.copyWith(color: C.navy)),
                      ]),
                      const SizedBox(height: 10),
                      ...const [
                        'Predict relapse risk with AI',
                        'Personalize your recovery plan',
                        'Alert your support network when needed',
                        'Improve our algorithms',
                      ].map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('• ',
                              style: TextStyle(
                                  color: C.navy, fontSize: 16, height: 1.2)),
                          Expanded(
                            child: Text(item,
                                style: T.bodySmall
                                    .copyWith(color: C.navy)),
                          ),
                        ]),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 18),

                  // ── Consent checkbox ─────────────────────────────
                  GestureDetector(
                    onTap: () => setState(() {
                      _consented = !_consented;
                      _error = null;
                    }),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 22, height: 22,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          color: _consented ? C.navy : C.white,
                          border: Border.all(color: C.navy, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _consented
                            ? const Icon(Icons.check_rounded,
                                size: 15, color: C.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I consent to TRUST AI collecting and analyzing my '
                          'health data to provide predictive insights and '
                          'personalized recovery support. I understand my data '
                          'is protected under HIPAA',
                          style: T.bodySmall
                              .copyWith(color: C.text, height: 1.55),
                        ),
                      ),
                    ]),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    ErrorBanner(message: _error),
                  ],
                ]),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: BackNextRow(
              onBack: () => context.pop(),
              onNext: _complete,
              nextLabel: 'Complete',
              loading: _loading,
            ),
          ),
        ]),
      ),
    );
  }
}
