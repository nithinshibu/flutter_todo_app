# Subtask 1.3 — Info: Build the First Real Todo List

## Branch

`feature/todo-app-subtasks-1.3`

---

## Files Changed Summary

| File                                                            | Action       | Why                                                           |
| --------------------------------------------------------------- | ------------ | ------------------------------------------------------------- |
| `lib/features/todos/models/todo.dart`                           | **Created**  | The Todo data model + `TodoPriority` enum                     |
| `lib/features/todos/presentation/widgets/todo_item.dart`        | **Created**  | Reusable widget that displays one Todo                        |
| `lib/features/todos/presentation/screens/todo_home_screen.dart` | **Modified** | Replaced placeholder with real `ListView.builder` + mock data |

---

## Folder Structure After This Subtask

```text
lib/
├── app/
│   └── app.dart
├── features/
│   └── todos/
│       ├── models/
│       │   └── todo.dart                ← NEW
│       └── presentation/
│           ├── screens/
│           │   └── todo_home_screen.dart  ← MODIFIED
│           └── widgets/
│               └── todo_item.dart         ← NEW
└── main.dart
```

---

## What Changed and Why

### `lib/features/todos/models/todo.dart` — Created

**What it contains:**

- `TodoPriority` enum (`low`, `medium`, `high`)
- `Todo` class with 5 fields: `id`, `title`, `description`, `priority`, `isCompleted`

**Why an enum for priority?**
If priority were a plain `String`, nothing would stop code from assigning `'URGENT'`, `'Hgh'`, or `''` — typos would be silent bugs. An enum makes the set of valid values finite and compiler-checked.

```dart
enum TodoPriority { low, medium, high }
```

**.NET Parallel:** `public enum TodoPriority { Low, Medium, High }`

**Why a class for Todo?**
A typed class gives you:

1. Named, typed fields — not `todo['title']` but `todo.title`
2. IDE autocomplete
3. Compile-time safety (missing fields are errors)
4. A place to add methods later (`copyWith`, `toJson`, etc.)

**Key Dart concepts introduced:**

- `final` fields — assigned once in the constructor, never changed
- Named parameters `{}` — caller must name each argument (self-documenting)
- `required` — forces the caller to provide a value (null-safe)
- `this.id` shorthand — assigns the parameter directly to the field (no boilerplate)
- `isCompleted = false` — optional parameter with a default value

```dart
const Todo({
  required this.id,
  required this.title,
  required this.description,
  required this.priority,
  this.isCompleted = false,   // optional, defaults to false
});
```

---

### `lib/features/todos/presentation/widgets/todo_item.dart` — Created

**What it does:** Renders the visual representation of ONE `Todo` object.

**Why is this a separate widget?**
Separation of concerns. The screen knows _"display a list of Todos"_. This widget knows _"here is how ONE Todo looks"_. If the design of a todo card changes, you only edit this one file. This is the same reason you extract a Blazor component or a WPF UserControl.

**.NET Parallel:** A `ContentView` in .NET MAUI or a `UserControl` in WPF.

**Key Flutter concepts introduced:**

| Widget     | Purpose                                                                        |
| ---------- | ------------------------------------------------------------------------------ |
| `Card`     | Material surface with shadow and rounded corners (like a `<div class="card">`) |
| `Padding`  | Adds spacing inside a container                                                |
| `Column`   | Stacks children vertically (like `StackPanel Orientation="Vertical"`)          |
| `Row`      | Lays children horizontally (like `StackPanel Orientation="Horizontal"`)        |
| `Expanded` | Fills remaining space in a Row/Column (like grid star `*` sizing in MAUI)      |
| `SizedBox` | Fixed-size spacer between elements                                             |
| `Icon`     | Material icon widget                                                           |
| `Text`     | Displays styled text                                                           |

**Visual structure of one TodoItem:**

```text
Card
└── Padding
    └── Column
        ├── Row
        │   ├── Icon (✔ or ○)
        │   └── Expanded → Text (title, strikethrough if done)
        ├── SizedBox (spacing)
        ├── Padding → Text (description, grey)
        ├── SizedBox (spacing)
        └── Padding → Container → Text (priority badge)
```

**Dart concept — switch expression (Dart 3+):**

```dart
return switch (priority) {
  TodoPriority.high   => 'High Priority',
  TodoPriority.medium => 'Medium Priority',
  TodoPriority.low    => 'Low Priority',
};
```

Every enum case must be handled or the compiler warns you — exhaustive by design.
**.NET Parallel:** C# pattern matching `switch` expression.

---

### `lib/features/todos/presentation/screens/todo_home_screen.dart` — Modified

**What changed:**

- Removed the placeholder `Center(child: Text(...))` body
- Added `final List<Todo> todos = [...]` — 5 mock Todo items
- Replaced the body with `ListView.builder`

**Why `ListView.builder` instead of `Column`?**

|               | Column                               | ListView.builder                  |
| ------------- | ------------------------------------ | --------------------------------- |
| Rendering     | Eager — all children created at once | Lazy — only visible items created |
| Scrolling     | Overflows if content exceeds screen  | Built-in scrolling                |
| Performance   | Bad for many items                   | Efficient for any number of items |
| .NET Parallel | Render all rows                      | Virtual scrolling / windowed list |

For 5 items there's no visible difference. For 500, `ListView.builder` is dramatically faster.

**How `itemBuilder` works:**

```dart
itemBuilder: (context, index) {
  final Todo currentTodo = todos[index];
  return TodoItem(todo: currentTodo);
},
```

Flutter calls this function once per visible item, passing the 0-based index. It's a lambda:
**.NET Parallel:** `(index) => new TodoItemView(todos[index])`

**Key Dart concept — `List<Todo>`:**
A generic typed list. `<Todo>` means "this list can only hold Todo objects". If you tried `todos.add("a string")`, it would be a compile error.
**.NET Parallel:** `List<Todo>` in C# — identical syntax!

---

## Data Flow

```text
Todo (data model)
    │
    │   stored in
    ▼
List<Todo> todos    (inside TodoHomeScreen.build())
    │
    │   passed into itemBuilder one at a time
    ▼
TodoItem(todo: currentTodo)
    │
    │   renders as
    ▼
Card → Column → Row + Icon + Text + priority badge
```

---

## Full Widget Tree After This Subtask

```text
TodoApp
└── MaterialApp
    └── TodoHomeScreen
        └── Scaffold
            ├── AppBar
            │   └── Text('My Todos')
            └── ListView.builder
                ├── TodoItem (id: 1 — Learn Flutter, HIGH, ○)
                ├── TodoItem (id: 2 — Build Todo App, MEDIUM, ○)
                ├── TodoItem (id: 3 — Understand Widgets, LOW, ✔ strikethrough)
                ├── TodoItem (id: 4 — Explore pubspec.yaml, LOW, ✔ strikethrough)
                └── TodoItem (id: 5 — Study Dart, HIGH, ○)
```

---

## How to Test in Chrome

### Step 1 — Static analysis

```bash
flutter analyze
```

Expected: `No issues found!` ✅

### Step 2 — Run in Chrome

```bash
flutter run -d chrome
```

**What you should see:**

- ✅ Indigo AppBar with "My Todos" title
- ✅ 5 Todo cards in a scrollable list
- ✅ Cards 1, 2, 5 — circle icon ○ (incomplete), normal text
- ✅ Cards 3, 4 — check icon ✔ (green), strikethrough title, dimmed text
- ✅ Each card shows a colored priority badge (red=High, orange=Medium, green=Low)
- ✅ No errors or warnings

---

## Small Experiments (Try these while the app is running)

### Experiment A — Add another Todo

In `todo_home_screen.dart`, add a new item to the `todos` list:

```dart
const Todo(
  id: '6',
  title: 'Practice Hot Reload',
  description: 'Save a file and watch Flutter update instantly',
  priority: TodoPriority.medium,
  isCompleted: false,
),
```

Save → a 6th card appears instantly in Chrome without restart.

### Experiment B — Change a Todo's completion state

In `todo_home_screen.dart`, find the first Todo and set `isCompleted: true`:

```dart
const Todo(id: '1', ..., isCompleted: true),
```

Save → the "Learn Flutter" card gets a green ✔ and strikethrough text.

### Experiment C — Change a priority

Change `priority: TodoPriority.high` to `priority: TodoPriority.low` on any item.
Save → the priority badge color and label update immediately.

---

## Dart Concepts Summary Table

| Concept                     | Where Used                  | .NET Parallel                             |
| --------------------------- | --------------------------- | ----------------------------------------- |
| `enum`                      | `TodoPriority`              | `public enum TodoPriority`                |
| `class` with `final` fields | `Todo`                      | `public class` with `get`-only properties |
| Named parameters `{}`       | `Todo` constructor          | Named args in C# method calls             |
| `required`                  | `Todo` constructor params   | Non-nullable constructor params           |
| Default values              | `isCompleted = false`       | `bool isCompleted = false` in C#          |
| `List<Todo>`                | `todos` in `TodoHomeScreen` | `List<Todo>` in C#                        |
| Switch expression           | `_priorityLabel()`          | C# switch expression                      |
| Lambda / anonymous function | `itemBuilder`               | C# `Func<>` or lambda `=>`                |

---

## Flutter Concepts Summary Table

| Concept           | Widget/API         | Purpose                                               |
| ----------------- | ------------------ | ----------------------------------------------------- |
| Lazy list         | `ListView.builder` | Creates widgets only for visible items                |
| Card surface      | `Card`             | Material container with elevation and rounded corners |
| Vertical layout   | `Column`           | Stacks children top-to-bottom                         |
| Horizontal layout | `Row`              | Places children left-to-right                         |
| Remaining space   | `Expanded`         | Fills leftover Row/Column space                       |
| Spacing           | `SizedBox`         | Fixed gap between widgets                             |
| Inner spacing     | `Padding`          | Space between a widget's border and its content       |
| Conditional UI    | Ternary `? :`      | Different widget based on `isCompleted` value         |

---

## Suggested Git Commit Message

```
feat: add todo model and display first real todo list with reusable item widget
```
