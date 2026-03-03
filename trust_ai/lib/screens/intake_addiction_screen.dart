// lib/screens/intake_addiction_screen.dart
//
// Dart equivalent of trustai-app/screens/IntakeAddictionScreen.js
// Calls POST /api/intake/addiction
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

const _kAddictionTypes = [
  'Alcohol',      'Nicotine',
  'Opioids',      'Cannabis',
  'Gambling',     'Gaming',
  'Social Media', 'Other',
];

class IntakeAddictionScreen extends StatefulWidget {
  const IntakeAddictionScreen({super.key});

  @override
  State<IntakeAddictionScreen> createState() => _State();
}

class _State extends State<IntakeAddictionScreen> {
  // Single-select — mirrors the RN toggle logic
  String? _selected;
  bool    _loading = false;
  String? _error;

  void _toggle(String item) => setState(() {
    _selected = _selected == item ? null : item;
    _error = null;
  });

  Future<void> _continue() async {
    if (_selected == null) {
      setState(() => _error = 'Please select your primary recovery focus.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiService.i.submitAddiction([_selected!]);
      if (mounted) context.push('/intake/support');
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
          const StepProgressBar(step: 3, total: 5),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: IntakeCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Primary Addiction Type', style: T.h3),
                  const SizedBox(height: 4),
                  Text('Select your primary recovery focus',
                      style: T.bodySmall),
                  const SizedBox(height: 16),

                  // Single-select: wrap in list of zero or one item
                  SelectionGrid(
                    items: _kAddictionTypes,
                    selected: _selected != null ? [_selected!] : [],
                    onToggle: _toggle,
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
              onNext: _continue,
              loading: _loading,
            ),
          ),
        ]),
      ),
    );
  }
}
