// TodoHomeScreen — The main Todo list screen.
//
// Updated in Subtask 1.5:
//   - Added _navigateToAdd() — pushes AddTodoScreen, awaits result, adds todo
//   - Added _navigateToEdit() — pushes EditTodoScreen, awaits result, updates todo
//   - Added _deleteTodo() — removes a todo from the list via setState
//   - Added FloatingActionButton to navigate to AddTodoScreen
//   - Passes onEdit callback to TodoItem
//   - Introduces async/await with Navigator and the 'mounted' safety check

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';
import 'package:todo_app/features/todos/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/features/todos/presentation/screens/edit_todo_screen.dart';
import 'package:todo_app/features/todos/presentation/widgets/todo_item.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
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

  // ── _toggleTodo() — Unchanged from Subtask 1.4 ──────────────────────────
  void _toggleTodo(String id) {
    setState(() {
      _todos = _todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
    });
  }

  // ── _deleteTodo() — Remove a todo from the list ──────────────────────────
  //
  // Called from EditTodoScreen via the onDelete callback.
  // Uses List.where() to keep only todos that do NOT have the given id.
  //
  // .NET Parallel (LINQ):
  //   _todos = _todos.Where(t => t.Id != id).ToList();
  void _deleteTodo(String id) {
    setState(() {
      _todos = _todos.where((todo) => todo.id != id).toList();
    });
  }

  // ── _navigateToAdd() — Navigate to AddTodoScreen ─────────────────────────
  //
  // This method is 'async' because Navigator.push returns a Future.
  // We 'await' it so we can read the result when the user comes back.
  //
  // Navigator.push<Todo>(context, route):
  //   - Pushes a new screen onto the navigation stack.
  //   - The <Todo> type parameter tells Dart what type to expect back.
  //   - Returns a Future<Todo?> — null if the user cancelled (pressed back).
  //
  // MaterialPageRoute:
  //   - The standard slide-transition route in Material apps.
  //   - builder: receives a context and returns the screen widget.
  //
  // .NET Parallel:
  //   await navigationService.NavigateToAsync("AddTodo");
  //   var result = dialog.ShowDialog(); // returns DialogResult + data
  //
  // 'mounted' check:
  //   After any 'await', the widget might have been removed from the tree
  //   (e.g., user navigated away). Calling setState on a dismounted widget
  //   throws an error. The 'mounted' property is true while the State is
  //   still in the tree. Always check it after an await before using context
  //   or calling setState.
  Future<void> _navigateToAdd() async {
    // Push the add screen and wait for it to pop back.
    // The result is the Todo the user created, or null if they pressed back.
    final newTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoScreen()),
    );

    // IMPORTANT: Check mounted after every await.
    // If the user navigated away from TodoHomeScreen while AddTodoScreen
    // was open (rare but possible), 'this' State is no longer mounted.
    // Calling setState on it would throw an error.
    if (!mounted) return;

    // Only add if the user actually submitted (not null = they saved)
    if (newTodo != null) {
      setState(() {
        // Spread operator [...existing, newItem] creates a new list
        // with all existing todos plus the new one at the end.
        //
        // .NET Parallel: _todos.Add(newTodo) — but immutable style.
        _todos = [..._todos, newTodo];
      });
    }
  }

  // ── _navigateToEdit() — Navigate to EditTodoScreen ───────────────────────
  //
  // Passes the current todo to EditTodoScreen and passes _deleteTodo
  // as the onDelete callback.
  Future<void> _navigateToEdit(Todo todo) async {
    final updatedTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoScreen(
          todo: todo,
          // Pass _deleteTodo as the onDelete callback.
          // We use a closure to capture the specific todo's id.
          // When EditTodoScreen calls onDelete(), this lambda runs,
          // which calls _deleteTodo with the correct id.
          onDelete: () => _deleteTodo(todo.id),
        ),
      ),
    );

    if (!mounted) return;

    // updatedTodo is null if user pressed back or deleted (delete calls its
    // own Navigator.pop without a result). Only update if there's a real result.
    if (updatedTodo != null) {
      setState(() {
        // Replace the old todo with the updated version, keep everything else.
        _todos = _todos.map((t) {
          return t.id == updatedTodo.id ? updatedTodo : t;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),

      body: _todos.isEmpty
          // ── Empty state ────────────────────────────────────────────────
          // When all todos are deleted, show a friendly empty state instead
          // of a blank screen. Good UX — users know what to do next.
          ? const Center(
              child: Text(
                'No todos yet.\nTap + to add your first one!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          // ── Todo list ──────────────────────────────────────────────────
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final Todo currentTodo = _todos[index];
                return TodoItem(
                  todo: currentTodo,
                  onToggle: () => _toggleTodo(currentTodo.id),
                  // Pass a closure that navigates to edit for this specific todo.
                  // The closure captures 'currentTodo' from this iteration.
                  onEdit: () => _navigateToEdit(currentTodo),
                );
              },
            ),

      // ── FloatingActionButton ───────────────────────────────────────────
      //
      // The FAB is the primary action button in Material Design.
      // Floating means it floats above the content in the bottom-right corner.
      //
      // onPressed calls _navigateToAdd() — because that method is async,
      // we could also write: onPressed: () => _navigateToAdd()
      // but the tear-off form is clean: onPressed: _navigateToAdd
      //
      // .NET Parallel: The primary toolbar button or a prominent CTA button.
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
