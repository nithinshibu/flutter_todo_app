// TodoHomeScreen — The main Todo list screen.
//
// Updated in Subtask 1.4:
//   - Converted from StatelessWidget to StatefulWidget
//   - The Todo list is now mutable state owned by _TodoHomeScreenState
//   - _toggleTodo() updates a todo's isCompleted using copyWith() + setState()
//   - TodoItem receives an onToggle callback pointing at _toggleTodo
//
// WHY StatefulWidget now?
//   In Subtask 1.3 the data was static — it never changed.
//   A StatelessWidget is perfect for that.
//   Now we need the screen to REACT to user input (tapping a todo).
//   The list must update and the UI must rebuild.
//   That requires STATE — and StatefulWidget is how Flutter manages
//   local mutable state.
//
// .NET Parallel:
//   Think of this like converting a read-only Razor Page into one
//   with a mutable ViewModel that raises PropertyChanged notifications.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';
import 'package:todo_app/features/todos/presentation/widgets/todo_item.dart';

// ── StatefulWidget ─────────────────────────────────────────────────────────
//
// A StatefulWidget is split into TWO classes in Dart:
//
//   1. The widget class (TodoHomeScreen)
//      - Immutable, like all widgets
//      - Its only job is to create the State object
//      - Holds configuration that doesn't change (e.g., constructor params)
//
//   2. The State class (_TodoHomeScreenState)
//      - Mutable — this is where variables that change over time live
//      - Owns the build() method
//      - Calling setState() here triggers a UI rebuild
//
// Why two classes?
//   Flutter's architecture keeps the widget blueprint (cheap, immutable)
//   separate from the mutable state (long-lived). This allows Flutter to
//   recreate widget objects frequently without losing state.
//
// .NET Parallel:
//   StatefulWidget ≈ the ViewModel class declaration
//   State          ≈ the ViewModel instance with its observable properties

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  // createState() is called once by Flutter when this widget is first
  // inserted into the widget tree. It returns the associated State object.
  // After that, Flutter keeps the State alive until the widget is removed.
  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

// ── State class ─────────────────────────────────────────────────────────────
//
// The leading underscore (_) makes this class private to this file.
// External code should never need to reference _TodoHomeScreenState directly.
//
// .NET Parallel: A private implementation class / ViewModel backing class.
class _TodoHomeScreenState extends State<TodoHomeScreen> {
  // _todos is the mutable list of Todo items.
  //
  // It lives here in the State because it needs to:
  //   1. Survive widget rebuilds (StatelessWidget cannot do this)
  //   2. Change in response to user actions
  //   3. Trigger a UI update when changed (via setState)
  //
  // The underscore prefix makes it private to this class.
  //
  // .NET Parallel:
  //   private ObservableCollection<Todo> _todos = new() { ... };
  //
  // Note: In Subtask 1.7 this list will move into a Riverpod provider.
  //   For now, local State is the right tool — we don't yet need to share
  //   this state with other screens.
  List<Todo> _todos = [
    const Todo(
      id: '1',
      title: 'Learn Flutter',
      description: 'Understand widgets, layouts, and the widget tree',
      priority: TodoPriority.high,
      isCompleted: false,
    ),
    const Todo(
      id: '2',
      title: 'Build Todo Application',
      description: 'Create a production-style learning project step by step',
      priority: TodoPriority.medium,
      isCompleted: false,
    ),
    const Todo(
      id: '3',
      title: 'Understand Widget Composition',
      description: 'Practice combining StatelessWidgets into a real UI',
      priority: TodoPriority.low,
      isCompleted: true,
    ),
    const Todo(
      id: '4',
      title: 'Explore pubspec.yaml',
      description: 'Learn how Flutter manages packages and assets',
      priority: TodoPriority.low,
      isCompleted: true,
    ),
    const Todo(
      id: '5',
      title: 'Study the Dart Language',
      description: 'Learn classes, enums, generics, and null safety',
      priority: TodoPriority.high,
      isCompleted: false,
    ),
  ];

  // ── _toggleTodo() — The state-change method ─────────────────────────────
  //
  // Called when the user taps a TodoItem card.
  // Receives the id of the todo that was tapped.
  //
  // The flow every time a todo is tapped:
  //
  //   User taps card
  //       ↓
  //   InkWell.onTap fires
  //       ↓
  //   onToggle() callback in TodoItem is called
  //       ↓
  //   _toggleTodo(id) is called here
  //       ↓
  //   setState() is called
  //       ↓
  //   Flutter knows state changed → schedules a rebuild
  //       ↓
  //   build() runs again with updated _todos
  //       ↓
  //   ListView rebuilds the affected TodoItem with new isCompleted value
  //       ↓
  //   UI updates on screen
  //
  // .NET Parallel:
  //   private void ToggleTodo(string id) {
  //       var todo = _todos.FirstOrDefault(t => t.Id == id);
  //       if (todo != null) todo.IsCompleted = !todo.IsCompleted;
  //       // PropertyChanged / StateHasChanged equivalent → setState()
  //   }
  void _toggleTodo(String id) {
    // setState() is the Flutter signal that says:
    //   "Something inside my State has changed — please rebuild my widget."
    //
    // The function passed to setState() is where you actually mutate state.
    // Flutter guarantees build() will be called again after setState() completes.
    //
    // IMPORTANT: Always mutate state INSIDE the setState callback, not before.
    setState(() {
      // map() iterates every todo in the list and transforms each one.
      // For the todo with the matching id, we produce a toggled copy.
      // For all others, we return them unchanged.
      //
      // This is the immutable update pattern:
      //   - We never do: todo.isCompleted = !todo.isCompleted (compile error!)
      //   - We use copyWith() to create a NEW Todo with the updated field
      //   - We replace the entire list with a new list
      //
      // .NET Parallel (LINQ):
      //   _todos = _todos.Select(t =>
      //       t.Id == id ? t with { IsCompleted = !t.IsCompleted } : t
      //   ).ToList();
      _todos = _todos.map((todo) {
        if (todo.id == id) {
          // This todo was tapped — return a copy with toggled isCompleted
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        // This todo was not tapped — return it unchanged
        return todo;
      }).toList(); // .toList() converts the lazy Iterable back to a List
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final Todo currentTodo = _todos[index];

          return TodoItem(
            todo: currentTodo,

            // Pass _toggleTodo as the onToggle callback.
            //
            // () => _toggleTodo(currentTodo.id)  is an anonymous function
            // (a closure) that captures currentTodo.id.
            //
            // Why not just:  onToggle: _toggleTodo
            //   Because _toggleTodo takes a String argument (the id),
            //   but onToggle expects VoidCallback (no arguments).
            //   The closure bridges this: it takes no args and calls
            //   _toggleTodo with the correct id captured from the loop.
            //
            // .NET Parallel:
            //   onToggle: () => ToggleTodo(currentTodo.Id)
            onToggle: () => _toggleTodo(currentTodo.id),
          );
        },
      ),
    );
  }
}
