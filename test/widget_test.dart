// Widget test for the Todo application.
//
// This test verifies that the TodoApp boots correctly and that
// the initial TodoHomeScreen is displayed.
//
// Updated in Subtask 1.2: replaced the original counter smoke test
// (which referenced the removed MyApp / counter widgets) with a
// basic smoke test that matches the new application structure.

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app/app.dart';

void main() {
  testWidgets('TodoApp launches and shows the home screen', (
    WidgetTester tester,
  ) async {
    // Build TodoApp and trigger a frame.
    await tester.pumpWidget(const TodoApp());

    // Verify the AppBar title is visible.
    expect(find.text('My Todos'), findsOneWidget);

    // Verify the placeholder body text is shown.
    expect(find.textContaining('Todo application foundation'), findsOneWidget);
  });
}
