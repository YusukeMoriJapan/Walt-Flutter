import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:walt/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('group', () {
    testWidgets('start', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
  });
}
