// lib/widgets/widgets.dart
//
// Single import for all shared UI components.
// Each widget maps 1-to-1 with a pattern from the RN screens.
//
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PROGRESS BAR  (replaces the step/progress header on each intake screen)
// ═══════════════════════════════════════════════════════════════════════════
class StepProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const StepProgressBar({super.key, required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Step $step of $total', style: T.caption),
          Text('${(step / total * 100).round()}%',
              style: T.caption.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: step / total,
            minHeight: 4,
            backgroundColor: C.border,
            valueColor: const AlwaysStoppedAnimation(C.navy),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CLINICAL HEADER  (brain icon + "Clinical-Grade Intake" — steps 2-5)
// ═══════════════════════════════════════════════════════════════════════════
class ClinicalHeader extends StatelessWidget {
  const ClinicalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(children: [
        Container(
          width: 64, height: 64,
          decoration: const BoxDecoration(
              color: C.intakeBg, shape: BoxShape.circle),
          child: const Icon(Icons.psychology_rounded,
              size: 34, color: C.navy),
        ),
        const SizedBox(height: 12),
        Text('Clinical-Grade Intake', style: T.h2, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(
          'This assessment helps us predict and prevent\nrelapse with AI-powered precision',
          style: T.bodySmall,
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INTAKE CARD  (white shadow card wrapping question + options)
// ═══════════════════════════════════════════════════════════════════════════
class IntakeCard extends StatelessWidget {
  final Widget child;
  const IntakeCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
        boxShadow: [
          BoxShadow(
              color: C.cardShadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIMARY BUTTON
// ═══════════════════════════════════════════════════════════════════════════
class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool arrow;

  const PrimaryBtn({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.arrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        child: loading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: C.white))
            : Row(mainAxisSize: MainAxisSize.min, children: [
                Text(label, style: T.btn),
                if (arrow) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: C.white),
                ],
              ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OUTLINE BUTTON  (Back, Sign In secondary)
// ═══════════════════════════════════════════════════════════════════════════
class OutlineBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const OutlineBtn({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: C.text)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BACK + NEXT ROW
// ═══════════════════════════════════════════════════════════════════════════
class BackNextRow extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;
  final bool loading;

  const BackNextRow({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Continue',
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: OutlineBtn(label: 'Back', onTap: onBack)),
      const SizedBox(width: 12),
      Expanded(
        child: PrimaryBtn(
          label: nextLabel,
          onTap: onNext,
          loading: loading,
          arrow: nextLabel == 'Continue',
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FORM FIELD  (icon + label + input — replaces the inputWrap pattern in RN)
// ═══════════════════════════════════════════════════════════════════════════
class AppFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType keyboard;
  final bool obscure;
  final Widget? suffix;
  final TextInputAction action;
  final VoidCallback? onSubmit;
  final FocusNode? focus;
  final String? autofill;
  final bool autocapWords;

  const AppFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.errorText,
    this.keyboard = TextInputType.text,
    this.obscure = false,
    this.suffix,
    this.action = TextInputAction.next,
    this.onSubmit,
    this.focus,
    this.autofill,
    this.autocapWords = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: T.label),
      const SizedBox(height: 7),
      TextFormField(
        controller: controller,
        focusNode: focus,
        keyboardType: keyboard,
        obscureText: obscure,
        textInputAction: action,
        textCapitalization: autocapWords
            ? TextCapitalization.words
            : TextCapitalization.none,
        onFieldSubmitted: (_) => onSubmit?.call(),
        autofillHints: autofill != null ? [autofill!] : null,
        style: T.body,
        decoration: InputDecoration(
          hintText: hint,
          errorText: errorText,
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: suffix,
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DROPDOWN FIELD  (tappable — opens bottom-sheet picker)
// ═══════════════════════════════════════════════════════════════════════════
class AppDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final String? errorText;
  final VoidCallback onTap;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.value,
    this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: T.label),
      const SizedBox(height: 7),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            color: C.inputBg,
            border: Border.all(
                color: errorText != null ? C.red : C.border, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(icon, size: 20, color: C.navy),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                filled ? value! : hint,
                style: T.body.copyWith(
                    color: filled ? C.text : C.hint),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: C.muted),
          ]),
        ),
      ),
      if (errorText != null) ...[
        const SizedBox(height: 5),
        Text(errorText!,
            style: GoogleFonts.inter(fontSize: 12, color: C.red)),
      ],
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PICKER BOTTOM SHEET  (replaces DropdownModal from RegisterScreen.js)
// ═══════════════════════════════════════════════════════════════════════════
Future<void> showPickerSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  required ValueChanged<String> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _PickerSheet(title: title, items: items, onSelect: onSelect),
  );
}

class _PickerSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onSelect;

  const _PickerSheet(
      {required this.title,
      required this.items,
      required this.onSelect});

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  final _ctrl = TextEditingController();
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _ctrl.addListener(() {
      final q = _ctrl.text.toLowerCase();
      setState(() => _filtered = q.isEmpty
          ? widget.items
          : widget.items
              .where((i) => i.toLowerCase().contains(q))
              .toList());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          // Handle
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 4),
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: C.border,
                borderRadius: BorderRadius.circular(100)),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: T.h3),
                IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1, color: C.border),
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              style: T.body,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: C.muted, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                filled: true,
                fillColor: C.inputBg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: C.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: C.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: C.navy)),
              ),
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              controller: sc,
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: C.border),
              itemBuilder: (_, i) => ListTile(
                title: Text(_filtered[i], style: T.body),
                onTap: () {
                  widget.onSelect(_filtered[i]);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SELECTION GRID  (2-col option buttons — replaces the grid in all intake screens)
// ═══════════════════════════════════════════════════════════════════════════
class SelectionGrid extends StatelessWidget {
  final List<String> items;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const SelectionGrid({
    super.key,
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.55,
      ),
      itemCount: items.length,
      itemBuilder: (_, idx) {
        final item = items[idx];
        final on = selected.contains(item);
        return GestureDetector(
          onTap: () => onToggle(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: C.white,
              border: Border.all(
                  color: on ? C.navy : C.border,
                  width: on ? 2 : 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                color: on ? C.navy : C.text,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ERROR BANNER  (red inline error — replaces Alert.alert for field errors)
// ═══════════════════════════════════════════════════════════════════════════
class ErrorBanner extends StatelessWidget {
  final String? message;
  const ErrorBanner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: C.redBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: C.red.withOpacity(0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline_rounded, color: C.red, size: 18),
        const SizedBox(width: 10),
        Expanded(
            child: Text(message!,
                style: GoogleFonts.inter(
                    fontSize: 13, color: C.red))),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SOCIAL BUTTON  (Google / Apple sign-in row)
// ═══════════════════════════════════════════════════════════════════════════
class SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const SocialBtn(
      {super.key,
      required this.label,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: C.border, width: 1.5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 20, color: C.text),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: C.text)),
      ]),
    );
  }
}
