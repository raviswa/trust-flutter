
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trust_ai/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen has a title and message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Verify that our title and message are present.
    expect(find.text('Welcome to Trust AI'), findsOneWidget);
    expect(find.text('Your personalized recovery companion\nfor digital wellness'), findsOneWidget);
  });
}
