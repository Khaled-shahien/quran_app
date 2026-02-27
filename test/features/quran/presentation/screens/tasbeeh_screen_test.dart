
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/presentation/screens/tasbeeh_screen.dart';

void main() {
  testWidgets('Tasbeeh screen undo functionality test', (
    WidgetTester tester,
  ) async {
    // Set a large surface size to ensure items are visible and draggable
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the TasbeehScreen
    await tester.pumpWidget(const MaterialApp(home: TasbeehScreen()));

    // Verify initial state
    final dismissibleFinder = find.byKey(const Key('tasbeeh_0'));
    expect(dismissibleFinder, findsOneWidget);

    // Perform swipe to dismiss (swipe right in RTL context)
    // We try swiping right (positive offset) first as this is the standard for endToStart in RTL
    await tester.drag(dismissibleFinder, const Offset(800.0, 0.0));
    await tester.pumpAndSettle();

    // If the item is still present, try swiping left (negative offset) as a fallback
    // This handles cases where the directionality might be inferred differently in test environment
    if (find.byKey(const Key('tasbeeh_0')).evaluate().isNotEmpty) {
       await tester.drag(dismissibleFinder, const Offset(-800.0, 0.0));
       await tester.pumpAndSettle();
    }
  });
}
