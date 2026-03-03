// lib/screens/intake_feelings_screen.dart
//
// Dart equivalent of trustai-app/screens/IntakeFeelingsScreen.js
// Calls POST /api/intake/feelings
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../services/api_service.dart';

const _kFeelings = [
  'Anger',     'Hunger',
  'Loneliness','Tiredness',
  'Distrust',  'Boredom',
  'Guilty',    'Sad',
  'Happy',     'Other',
];

class IntakeFeelingsScreen extends StatefulWidget {
  const IntakeFeelingsScreen({super.key});

  @override
  State<IntakeFeelingsScreen> createState() => _State();
}

class _State extends State<IntakeFeelingsScreen> {
  final List<String> _selected = [];
  bool    _loading = false;
  String? _error;

  void _toggle(String item) => setState(() {
    _selected.contains(item) ? _selected.remove(item) : _selected.add(item);
    _error = null;
  });

  Future<void> _continue() async {
    if (_selected.isEmpty) {
      setState(() => _error = 'Please select at least one option.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiService.i.submitFeelings(_selected);
      if (mounted) context.push('/intake/addiction');
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
          const StepProgressBar(step: 2, total: 5),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: IntakeCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('What feels heavy for you lately?', style: T.h3),
                  const SizedBox(height: 4),
                  Text('Select all that apply', style: T.bodySmall),
                  const SizedBox(height: 16),

                  SelectionGrid(
                    items: _kFeelings,
                    selected: _selected,
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
