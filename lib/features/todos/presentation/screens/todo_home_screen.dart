// TodoHomeScreen — The main Todo list screen.
//
// Responsibility (updated in Subtask 1.3):
//   - Own the temporary in-memory mock Todo data
//   - Display the full Todo list using ListView.builder
//   - Compose the list using the reusable TodoItem widget
//
// What this screen does NOT do:
//   - No state management (data is static for now)
//   - No Add/Edit/Delete (coming in Subtask 1.4 and 1.5)
//   - No database or persistence (coming in Subtask 1.8)
//
// The mock data here is intentionally temporary.
// In Subtask 1.4 it will be moved into a StatefulWidget's State.
// In Subtask 1.7 it will move into a Riverpod provider.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';
import 'package:todo_app/features/todos/presentation/widgets/todo_item.dart';

class TodoHomeScreen extends StatelessWidget {
  const TodoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Temporary Mock Data ────────────────────────────────────────────────
    //
    // List<Todo> is a generic typed list — it can only hold Todo objects.
    //
    // Why List<Todo> and not var or dynamic?
    //   Type safety: the Dart compiler knows what's in the list.
    //   If you accidentally tried to add a String, it would be a compile error.
    //
    // .NET Parallel:
    //   List<Todo> todos = new List<Todo> { ... }
    //   or:  IList<Todo> todos = [ ... ]  (C# 12 collection expression)
    //
    // The 'final' keyword means the list variable itself cannot be reassigned
    // (todos = someOtherList would be an error), but the list contents can
    // change. We'll address mutability when we introduce setState() in 1.4.
    final List<Todo> todos = [
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
        isCompleted: true, // this one is already done
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

    // ── Screen Layout ──────────────────────────────────────────────────────
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),

      // ── ListView.builder ───────────────────────────────────────────────
      //
      // Why ListView.builder instead of a plain Column?
      //
      //   Column renders ALL its children immediately, even those off-screen.
      //   ListView.builder is LAZY — it only creates the widgets for items
      //   that are currently visible (or just about to scroll into view).
      //
      //   For 5 items there is no difference. For 500 or 5000 items,
      //   ListView.builder is dramatically more efficient.
      //
      //   Think of it like:
      //   - Column → rendering the entire DataGrid eagerly
      //   - ListView.builder → virtual scrolling / windowing in WPF
      //
      // itemCount: tells Flutter how many items exist in total.
      //   Flutter uses this to know when to stop calling itemBuilder.
      //
      // itemBuilder: a function called once per visible item.
      //   Flutter calls it with the BuildContext and the item index (0-based).
      //   It must return the Widget for that item.
      //
      //   (context, index) => ...
      //   is a Dart anonymous function (lambda).
      //   .NET Parallel: (context, index) => new TodoItemView(todos[index])
      //
      body: ListView.builder(
        // A small amount of padding above and below the list
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          // todos[index] accesses the Todo at position 'index'.
          // This is called lazily by Flutter only when the item
          // needs to be displayed.
          final Todo currentTodo = todos[index];

          // Return a TodoItem for this Todo.
          // The screen doesn't know how a single Todo looks — that's
          // TodoItem's job. This separation is the key principle here.
          return TodoItem(todo: currentTodo);
        },
      ),
    );
  }
}
