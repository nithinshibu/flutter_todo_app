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
  // and never changed afterward. Todos are immutable value objects.
  //
  // To "change" a Todo (e.g. toggle isCompleted), we use copyWith() below
  // to create a brand-new Todo instance with the updated field.
  // The original Todo is discarded — we never mutate in place.
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

  // copyWith() — Creates a new Todo with some fields replaced.
  //
  // Because all fields are 'final', we cannot do:
  //   todo.isCompleted = true;   ← compile error!
  //
  // Instead, we call copyWith() to get a brand-new Todo object that
  // has the same values as the original, except for the fields we override:
  //
  //   final updated = todo.copyWith(isCompleted: true);
  //
  // The original 'todo' is not touched. We replace it in our list.
  // This is called the immutable update pattern.
  //
  // .NET Parallel:
  //   C# records support the 'with' expression:
  //     var updated = todo with { IsCompleted = true };
  //   copyWith() is the Dart equivalent — done manually because
  //   Dart doesn't have built-in 'with' expressions yet.
  //
  // Each parameter uses the nullable override trick:
  //   isCompleted ?? this.isCompleted
  //   → use the provided value if not null, otherwise keep the existing value.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoPriority? priority,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
