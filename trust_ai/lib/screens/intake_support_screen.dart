// lib/screens/intake_support_screen.dart
//
// Step 4 of 5 — Support Network
// Calls POST /api/intake/support
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

class _Option {
  final String name;
  final String desc;
  final String emoji;
  final Color  bg;
  const _Option(this.name, this.desc, this.emoji, this.bg);
}

const _kOptions = [
  _Option('Therapist / Counselor', 'Licensed mental health professional',
      '👨‍⚕️', Color(0xFFEFF6FF)),
  _Option('Family Member',         'Trusted family contact',
      '👨‍👩‍👧', Color(0xFFFFF7ED)),
  _Option('Sponsor / Peer Mentor', 'Recovery community support',
      '🤝', Color(0xFFF0FDF4)),
  _Option('Close Friend',          'Someone you trust completely',
      '👫', Color(0xFFFDF4FF)),
];

class IntakeSupportScreen extends StatefulWidget {
  const IntakeSupportScreen({super.key});

  @override
  State<IntakeSupportScreen> createState() => _State();
}

class _State extends State<IntakeSupportScreen> {
  // Pre-select therapist — matches the HTML default
  final Set<String> _selected = {'Therapist / Counselor'};
  bool    _loading = false;
  String? _error;

  Future<void> _continue() async {
    if (_selected.isEmpty) {
      setState(() => _error = 'Please select at least one support person.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiService.i.submitSupport(_selected.toList());
      if (mounted) context.push('/intake/privacy');
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
          const StepProgressBar(step: 4, total: 5),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: IntakeCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Your Support Network', style: T.h3),
                  const SizedBox(height: 4),
                  Text('Who can we alert in case of a crisis?',
                      style: T.bodySmall),
                  const SizedBox(height: 16),

                  ..._kOptions.map((opt) {
                    final on = _selected.contains(opt.name);
                    return GestureDetector(
                      onTap: () => setState(() {
                        on ? _selected.remove(opt.name)
                           : _selected.add(opt.name);
                        _error = null;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: on ? C.navyBg : C.white,
                          border: Border.all(
                              color: on ? C.navy : C.border,
                              width: on ? 2 : 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          // Emoji circle
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                                color: opt.bg, shape: BoxShape.circle),
                            child: Center(child: Text(opt.emoji,
                                style: const TextStyle(fontSize: 20))),
                          ),
                          const SizedBox(width: 14),
                          // Text
                          Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(opt.name, style: T.label),
                            Text(opt.desc, style: T.bodySmall),
                          ])),
                          // Check dot
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: on ? C.navy : Colors.transparent,
                              border: Border.all(
                                  color: on ? C.navy : C.border,
                                  width: 2),
                            ),
                            child: on
                                ? const Icon(Icons.check_rounded,
                                    size: 13, color: C.white)
                                : null,
                          ),
                        ]),
                      ),
                    );
                  }),

                  if (_error != null) ErrorBanner(message: _error),
                ]),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: BackNextRow(
              onBack: () => context.pop(),
              onNext: _continue,
              loading: _loading,
            ),
          ),
        ]),
      ),
    );
  }
}
