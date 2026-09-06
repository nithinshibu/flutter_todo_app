// todo.dart — The Todo data model.
//
// Responsibility:
//   - Define what a Todo IS (its properties and types)
//   - Define the TodoPriority enum
//
// What this file does NOT contain:
//   - No Flutter imports
//   - No UI code
//   - No database mapping (yet)
//   - No JSON serialization (yet)
//
// .NET Parallel:
//   This is equivalent to a C# model class or record — a plain data
//   container that describes the shape of a domain object.
//
//   C#:    public record Todo(string Title, bool IsCompleted, ...)
//   Dart:  class Todo { final String title; final bool isCompleted; ... }

// TodoPriority enum — Represents the urgency level of a Todo item.
//
// Why an enum and not a String?
//   If priority were a String, nothing would stop code from assigning
//   'URGENT', 'Hgh', or '' — typos would be silent bugs.
//   An enum makes the set of valid values finite and compile-time checked.
//
// .NET Parallel:
//   public enum TodoPriority { Low, Medium, High }
//   Dart enums work almost identically.
enum TodoPriority { low, medium, high }

// Todo — The core data class for a single Todo item.
//
// Each Todo has five fields for this stage of the application.
// We will add more fields (category, due date, etc.) in later subtasks
// when the application actually needs them.
//
// Why a class and not a Map<String, dynamic>?
//   A class gives you:
//   1. Named, typed fields — no guessing what keys exist or their types.
//   2. IDE autocomplete — todo.title, not todo['title'].
//   3. Compile-time safety — the compiler catches missing fields.
//   4. A clear place to add methods later (e.g., copyWith, toJson).
//
// .NET Parallel:
//   public class Todo {
//       public string Id { get; }
//       public string Title { get; }
//       public string Description { get; }
//       public TodoPriority Priority { get; }
//       public bool IsCompleted { get; }
//   }
class Todo {
  // 'final' means each field is assigned once in the constructor
  // and never changed afterward. Todos at this stage are immutable.
  // In Subtask 1.4 we will introduce copyWith() to create modified copies.
  //
  // .NET Parallel: { get; init; } properties or readonly fields.
  final String id;
  final String title;
  final String description;
  final TodoPriority priority;
  final bool isCompleted;

  // Constructor using named parameters.
  //
  // Why named parameters (the curly braces {})?
  //   They force the caller to name each argument, making call sites
  //   self-documenting and order-independent:
  //
  //   Todo(
  //     id: '1',
  //     title: 'Learn Flutter',     ← clear what each value means
  //     description: '...',
  //     priority: TodoPriority.high,
  //     isCompleted: false,
  //   )
  //
  // 'required' means the caller MUST provide this argument.
  //   Without it, the parameter would be optional (null-safe Dart would
  //   require a nullable type or a default value instead).
  //
  // .NET Parallel:
  //   public Todo(string id, string title, ...) — positional and required.
  //   Dart's named + required combination gives you the best of both worlds.
  //
  // 'this.id' is shorthand for: id = id (assigns the parameter to the field).
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false, // optional — defaults to false (not completed)
  });
}
