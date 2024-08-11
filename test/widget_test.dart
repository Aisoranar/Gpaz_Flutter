import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unipaz/main.dart';

void main() {
  testWidgets('Check tabs content', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isFirstLaunch: false, currentUser: null,));

    // Verify the initial tab content.
    expect(find.text('1ST TAB'), findsOneWidget);
    expect(find.text('2ND TAB'), findsNothing);
    expect(find.text('3RD TAB'), findsNothing);
    expect(find.text('4TH TAB'), findsOneWidget);

    // Tap the second tab and trigger a frame.
    await tester.tap(find.byIcon(Icons.person_add_alt_rounded));
    await tester.pumpAndSettle();

    // Verify the content of the second tab.
    expect(find.text('1ST TAB'), findsNothing);
    expect(find.text('2ND TAB'), findsOneWidget);
    expect(find.text('3RD TAB'), findsNothing);
    expect(find.text('4TH TAB'), findsOneWidget);

    // Tap the third tab and trigger a frame.
    await tester.tap(find.byIcon(Icons.three_p));
    await tester.pumpAndSettle();

    // Verify the content of the third tab.
    expect(find.text('1ST TAB'), findsNothing);
    expect(find.text('2ND TAB'), findsNothing);
    expect(find.text('3RD TAB'), findsOneWidget);
    expect(find.text('4TH TAB'), findsOneWidget);

    // Tap the fourth tab and trigger a frame.
    await tester.tap(find.byIcon(Icons.access_alarms));
    await tester.pumpAndSettle();

    // Verify the content of the fourth tab.
    expect(find.text('1ST TAB'), findsNothing);
    expect(find.text('2ND TAB'), findsNothing);
    expect(find.text('3RD TAB'), findsNothing);
    expect(find.text('4TH TAB'), findsOneWidget);
  });
}
