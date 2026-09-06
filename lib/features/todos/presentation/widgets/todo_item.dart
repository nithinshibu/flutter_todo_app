// todo_item.dart — A reusable widget that displays ONE Todo item.
//
// Responsibility:
//   - Render the visual representation of a single Todo
//   - Receive a Todo object through its constructor
//   - Receive an onToggle callback and invoke it when the user taps
//
// Updated in Subtask 1.4:
//   - Added 'onToggle' callback parameter (VoidCallback)
//   - Wrapped the card in InkWell so it is tappable
//   - The widget itself does NOT change any state — it only calls back
//     to its parent (TodoHomeScreen) which owns the state
//
// .NET Parallel:
//   A UserControl in WPF / ContentView in MAUI that raises an event
//   (e.g. TodoCompleted event) for the parent page to handle.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  // VoidCallback is a Dart type alias for: void Function()
  // It represents a function that takes no arguments and returns nothing.
  //
  // The parent (TodoHomeScreen) will pass in its _toggleTodo method here.
  // When the user taps this card, we call onToggle() — the parent handles
  // the actual state change.
  //
  // WHY does the widget not handle the toggle itself?
  //   TodoItem does not own the list. It does not know whether this is
  //   todo[2] or todo[99]. The parent owns the List<Todo> and knows
  //   which todo to update. This is the correct separation of concerns:
  //
  //   TodoItem: "The user tapped me — here's the notification." (onToggle)
  //   TodoHomeScreen: "Got it — I'll update the list." (setState)
  //
  // .NET Parallel:
  //   Like raising a RoutedEvent or an EventCallback<bool> in Blazor:
  //   [Parameter] public EventCallback OnToggle { get; set; }
  final VoidCallback onToggle;

  // onEdit — called when the user taps the edit (pencil) icon button.
  // The parent navigates to EditTodoScreen when this fires.
  // Same delegation principle as onToggle — the widget raises the event,
  // the parent decides what to do with it.
  final VoidCallback onEdit;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit, // added in Subtask 1.5
  });

  String _priorityLabel(TodoPriority priority) {
    return switch (priority) {
      TodoPriority.high => 'High Priority',
      TodoPriority.medium => 'Medium Priority',
      TodoPriority.low => 'Low Priority',
    };
  }

  Color _priorityColor(TodoPriority priority) {
    return switch (priority) {
      TodoPriority.high => Colors.red.shade700,
      TodoPriority.medium => Colors.orange.shade700,
      TodoPriority.low => Colors.green.shade700,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),

      // InkWell makes the entire Card tappable with a Material ripple effect.
      //
      // When the user taps anywhere on the card, InkWell calls its onTap
      // function — which calls our onToggle callback — which tells the
      // parent to toggle this todo's completion state.
      //
      // 'onTap: onToggle' is a function reference (tear-off).
      // We pass the function itself, not the result of calling it.
      // This is the same pattern as: button.Click += handler (not handler())
      //
      // The clipBehavior ensures the ripple ink stays inside the Card's
      // rounded corners.
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: Completion indicator + Title + Edit button ──────
              Row(
                children: [
                  Icon(
                    todo.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: todo.isCompleted ? Colors.green : Colors.grey,
                    size: 22.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted ? Colors.grey : null,
                      ),
                    ),
                  ),

                  // Edit icon button in the trailing position.
                  //
                  // IconButton handles its OWN tap independently of the
                  // surrounding InkWell. When the user taps this icon,
                  // only onEdit() fires — not onToggle().
                  //
                  // This works because IconButton uses its own GestureDetector
                  // internally, which absorbs the tap before InkWell sees it.
                  //
                  // .NET Parallel: A button inside a ListViewItem that handles
                  //   its own Click event without selecting the item.
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: 18.0,
                    color: Colors.grey.shade500,
                    tooltip: 'Edit todo',
                    // Call onEdit — the parent will navigate to EditTodoScreen
                    onPressed: onEdit,
                  ),
                ],
              ),

              // ── Description ────────────────────────────────────────────
              const SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  todo.description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                ),
              ),

              // ── Priority badge ─────────────────────────────────────────
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor(todo.priority)
                        .withValues(alpha: 0.12),
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
      ),
    );
  }
}
