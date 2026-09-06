// todo.dart — The Todo data model.
//
// Responsibility:
//   - Define what a Todo IS (its properties and types)
//   - Define enums: TodoPriority, TodoCategory
//
// Updated in Subtask 1.6:
//   - Added TodoCategory enum (personal, work, learning, health, shopping)
//   - Added 'category' field (required, replaces no-category state)
//   - Added 'dueDate' field (DateTime? — optional, nullable)
//   - Updated copyWith() with clearDueDate parameter
//
// What this file does NOT contain:
//   - No Flutter imports
//   - No UI code
//   - No database mapping (yet)
//   - No JSON serialization (yet)

// ── TodoPriority ─────────────────────────────────────────────────────────────
enum TodoPriority { low, medium, high }

// ── TodoCategory ─────────────────────────────────────────────────────────────
//
// Represents what area of life a Todo belongs to.
//
// Why an enum instead of a free-form String like 'Work' or 'Personal'?
//   Same reason as TodoPriority: the set of valid values is finite and
//   known at compile time. Typos become compiler errors, not runtime bugs.
//   It also makes switch expressions exhaustive — the compiler forces you
//   to handle every case.
//
// .NET Parallel:
//   public enum TodoCategory { Personal, Work, Learning, Health, Shopping }
enum TodoCategory { personal, work, learning, health, shopping }

// ── Todo ─────────────────────────────────────────────────────────────────────
//
// Updated in Subtask 1.6 to include category and optional due date.
//
// .NET Parallel:
//   public class Todo {
//       public string Id { get; }
//       public string Title { get; }
//       public string Description { get; }
//       public TodoPriority Priority { get; }
//       public TodoCategory Category { get; }
//       public bool IsCompleted { get; }
//       public DateTime? DueDate { get; }   // nullable
//   }
class Todo {
  final String id;
  final String title;
  final String description;
  final TodoPriority priority;

  // category — The area of life this Todo belongs to.
  // Required, defaults to personal.
  final TodoCategory category;

  final bool isCompleted;

  // dueDate — The optional deadline for this Todo.
  //
  // The trailing '?' makes this type NULLABLE — it can hold either a
  // DateTime value OR null (meaning "no due date set").
  //
  // Null safety in Dart:
  //   DateTime  dueDate  → must always have a value — compiler error if null
  //   DateTime? dueDate  → may be null — caller must check before using
  //
  // .NET Parallel:
  //   DateTime? DueDate { get; }   // same syntax in C#!
  //   Nullable<DateTime> DueDate   // equivalent long form
  final DateTime? dueDate;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.category = TodoCategory.personal, // optional, defaults to personal
    this.isCompleted = false,
    this.dueDate, // optional, defaults to null (no due date)
  });

  // copyWith() — Updated in Subtask 1.6.
  //
  // The challenge with nullable fields:
  //   The ?? (null-coalescing) trick works for non-nullable fields:
  //     title: title ?? this.title   → if title arg is null, keep existing
  //
  //   But for a nullable field like DateTime?:
  //     dueDate: dueDate ?? this.dueDate
  //   This CANNOT distinguish between:
  //     A) Caller didn't provide dueDate  → keep existing (dueDate param = null)
  //     B) Caller explicitly wants to CLEAR dueDate → set to null (dueDate param = null)
  //   Both cases pass null — so ?? can't tell them apart!
  //
  // Solution: a separate 'clearDueDate' boolean flag.
  //   clearDueDate: true  → set dueDate to null  (explicit clear)
  //   clearDueDate: false + dueDate: someDate → use the new date
  //   clearDueDate: false + dueDate: null  → keep existing date (no change)
  //
  // .NET Parallel:
  //   There is no exact equivalent — C# `with` expressions handle this
  //   naturally (todo with { DueDate = null } explicitly sets to null).
  //   Dart requires this extra parameter because it lacks `with` expressions.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoPriority? priority,
    TodoCategory? category,
    bool? isCompleted,
    DateTime? dueDate,
    bool clearDueDate = false, // explicitly set dueDate to null when true
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      // Ternary: if clearDueDate is true → null, otherwise use provided
      // dueDate or fall back to current value.
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
    );
  }
}
