import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integration smoke test boots widget tree', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Integration smoke test'))),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Integration smoke test'), findsOneWidget);
  });
}
