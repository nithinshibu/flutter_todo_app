// Widget test for the Todo application.
//
// Updated in Subtask 1.5: verifies the full home screen (with FAB),
// and that the todo list appears correctly on launch.
//
// The test boots TodoApp — which goes through the full
// main() → TodoApp → MaterialApp → TodoHomeScreen chain.

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app/app.dart';

void main() {
  testWidgets('TodoApp launches and shows the home screen with todos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    // Verify the AppBar title is visible.
    expect(find.text('My Todos'), findsOneWidget);

    // Verify at least one of the mock todos appears.
    expect(find.text('Learn Flutter'), findsOneWidget);

    // Verify the FloatingActionButton is present.
    expect(find.byTooltip('Add Todo'), findsOneWidget);
  });
}
