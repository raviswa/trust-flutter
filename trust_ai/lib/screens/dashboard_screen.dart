// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.white,
      body: SafeArea(
        child: Column(children: [

          // ── App bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.menu_rounded, size: 26, color: C.text),
                Row(children: [
                  Image.asset('assets/logo.png', width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text('TRUST AI',
                      style: T.label.copyWith(
                          fontSize: 15, letterSpacing: 0.5)),
                ]),
                IconButton(
                  icon: const Icon(Icons.logout_rounded,
                      size: 22, color: C.text),
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    if (context.mounted) context.go('/');
                  },
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image.asset('assets/logo.png', width: 110, height: 110),
                  const SizedBox(height: 24),
                  Text('Welcome to Trust AI! 🏄',
                      style: T.h2, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    'Your recovery journey begins here.\nFull dashboard coming in the next sprint.',
                    style: T.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ),

          // ── Bottom nav (matches Insights_1.jpg design) ───────────────────
          Container(
            color: C.navy,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded,
                    label: 'Home', active: true),
                _NavItem(icon: Icons.insights_rounded,
                    label: 'Insights', active: false),
                // Centre Check In button
                Container(
                  width: 52, height: 52,
                  decoration: const BoxDecoration(
                      color: C.white, shape: BoxShape.circle),
                  child: const Icon(Icons.add_rounded,
                      color: C.navy, size: 28),
                ),
                _NavItem(icon: Icons.chat_bubble_outline_rounded,
                    label: 'Message', active: false),
                _NavItem(icon: Icons.person_outline_rounded,
                    label: 'Profile', active: false),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     active;

  const _NavItem(
      {required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final col = active ? C.white : Colors.white54;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: col, size: 24),
      const SizedBox(height: 4),
      Text(label,
          style: TextStyle(
              color: col, fontSize: 11, fontWeight: FontWeight.w500)),
    ]);
  }
}
