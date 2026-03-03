// lib/screens/welcome_screen.dart
//
// Dart equivalent of trustai-app/screens/WelcomeScreen.js
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 20),

            // ── Top-right logo + wordmark ──────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Image.asset('assets/logo.png', width: 34, height: 34),
              const SizedBox(width: 8),
              Text('TRUST AI',
                  style: T.label.copyWith(
                      fontSize: 15, letterSpacing: 0.5)),
            ]),

            const SizedBox(height: 32),

            // ── Hero title ────────────────────────────────────────────
            Text('Welcome to Trust AI',
                style: T.h1, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
              'Your personalized recovery companion\nfor digital wellness',
              style: T.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // ── Logo ──────────────────────────────────────────────────
            Image.asset('assets/logo.png', width: 200, height: 200),

            const SizedBox(height: 48),

            // ── Begin Your Journey ────────────────────────────────────
            PrimaryBtn(
              label: 'Begin Your Journey',
              onTap: () => context.push('/register'),
            ),
            const SizedBox(height: 12),

            // ── Sign In ───────────────────────────────────────────────
            OutlineBtn(
              label: 'Sign In',
              onTap: () => context.push('/login'),
            ),

            const SizedBox(height: 20),

            // ── Coming-soon banner ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.bannerBg,
                border: Border.all(color: C.bannerBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                // Mindful AI icon
                Container(
                  width: 48, height: 48,
                  decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🧠',
                          style: TextStyle(fontSize: 18)),
                      Text('MINDFUL AI',
                          style: T.caption.copyWith(
                              fontSize: 7,
                              color: C.bannerLabel,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Children & Youth coming soon in Phase 2.',
                    style: T.bodySmall
                        .copyWith(color: C.bannerText),
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}
