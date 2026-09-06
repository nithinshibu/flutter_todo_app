// todo_item.dart — A reusable widget that displays ONE Todo item.
//
// Responsibility:
//   - Render the visual representation of a single Todo
//   - Receive a Todo object through its constructor (passed in from outside)
//   - Display: title, description, priority, and completion state
//
// What this widget does NOT do:
//   - It does NOT manage a list of Todos
//   - It does NOT contain state (no checkboxes that change yet — that's Subtask 1.4)
//   - It does NOT fetch or store data
//
// Why is this a separate widget and not inline in TodoHomeScreen?
//   Separation of concerns. The screen knows "show a list of Todos".
//   This widget knows "here is how ONE Todo looks". If the visual design
//   of a Todo item changes, you only change this one file — not every place
//   a Todo appears. This is the same reason you extract a C# UserControl
//   or a Blazor component instead of copy-pasting markup everywhere.
//
// .NET Parallel:
//   A UserControl in WinForms / WPF, a Razor Component in Blazor,
//   or a ContentView in .NET MAUI.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

// TodoItem is a StatelessWidget because it only displays data passed to it.
// It has no internal state that changes over time.
// In Subtask 1.4, when the checkbox becomes interactive, we will revisit this.
class TodoItem extends StatelessWidget {
  // The Todo to display. It is 'final' because this widget never replaces
  // the todo reference after construction.
  final Todo todo;

  // Constructor: the caller passes in a Todo instance.
  //
  // Usage from the parent:
  //   TodoItem(todo: myTodo)
  //
  // 'super.key' passes the optional Key to the parent StatelessWidget.
  // Keys help Flutter identify widgets when the list order changes.
  // We include it as a best practice but won't explain keys deeply yet.
  const TodoItem({super.key, required this.todo});

  // A small helper that converts a TodoPriority enum value into a
  // human-readable label string for the UI.
  //
  // Why a helper method instead of putting this logic inside build()?
  //   Keeps build() focused on widget composition.
  //   Logic that transforms data (model → display string) belongs
  //   in a helper, not mixed into the widget tree.
  //
  // .NET Parallel: A display formatter method or a ToString() override.
  String _priorityLabel(TodoPriority priority) {
    // Dart switch expressions (Dart 3+) — exhaustive, returns a value.
    // Every enum case must be handled or the compiler warns you.
    return switch (priority) {
      TodoPriority.high => 'High Priority',
      TodoPriority.medium => 'Medium Priority',
      TodoPriority.low => 'Low Priority',
    };
  }

  // A helper that picks a color for the priority label.
  // Colors give a quick visual cue without needing to read the label text.
  Color _priorityColor(TodoPriority priority) {
    return switch (priority) {
      TodoPriority.high => Colors.red.shade700,
      TodoPriority.medium => Colors.orange.shade700,
      TodoPriority.low => Colors.green.shade700,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Card is a Material 3 surface widget with a subtle shadow and
    // rounded corners. It visually groups related content together.
    // Think of it as a <div class="card"> in HTML or a Frame in WPF.
    return Card(
      // margin adds space around the outside of the Card (between Cards).
      // EdgeInsets.symmetric sets the same value on both horizontal sides
      // and both vertical sides independently.
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),

      // child: Padding adds space between the Card border and its content.
      child: Padding(
        padding: const EdgeInsets.all(12.0),

        // Column stacks its children vertically (top to bottom).
        // .NET Parallel: StackPanel with Orientation="Vertical" in WPF/MAUI.
        child: Column(
          // crossAxisAlignment controls child alignment on the horizontal
          // axis (since Column's main axis is vertical).
          // CrossAxisAlignment.start aligns children to the left edge.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Completion indicator + Title ──────────────────────
            // Row lays its children out horizontally (left to right).
            // .NET Parallel: StackPanel with Orientation="Horizontal".
            Row(
              children: [
                // The completion indicator: a simple icon that visually
                // shows whether the Todo is done or not.
                //
                // Ternary in Dart:  condition ? valueIfTrue : valueIfFalse
                // Same syntax as C#.
                Icon(
                  todo.isCompleted
                      ? Icons
                            .check_circle // filled circle ✔
                      : Icons.radio_button_unchecked, // empty circle ○
                  color: todo.isCompleted ? Colors.green : Colors.grey,
                  size: 22.0,
                ),

                // SizedBox is a fixed-size box used here purely for spacing.
                // .NET Parallel: <Grid ColumnSpacing="8"/> or a spacer.
                const SizedBox(width: 10.0),

                // Expanded fills the remaining horizontal space in the Row.
                // Without it, the Text might overflow if the title is long.
                // .NET Parallel: HorizontalAlignment="Stretch" or Grid star (*) column.
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      // Strike-through text decoration for completed todos.
                      // This is a common UX pattern to show something is done.
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      // Dim the text color when completed — secondary visual cue.
                      color: todo.isCompleted ? Colors.grey : null,
                    ),
                  ),
                ),
              ],
            ),

            // ── Spacing between title row and description ─────────────────
            const SizedBox(height: 6.0),

            // ── Description ───────────────────────────────────────────────
            // Padding indents the description to align under the title text
            // (past the icon and its spacing: 22 + 10 = 32 logical pixels).
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(
                todo.description,
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
              ),
            ),

            // ── Spacing before priority chip ──────────────────────────────
            const SizedBox(height: 8.0),

            // ── Priority label ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Container(
                // Decorative container acting as a colored label/badge.
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3.0,
                ),
                decoration: BoxDecoration(
                  // A very light tint of the priority color as background.
                  color: _priorityColor(todo.priority).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  _priorityLabel(todo.priority),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: _priorityColor(todo.priority),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
