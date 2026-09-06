# Subtask 1.5 — Info: Add/Edit Todo Screens and Navigation

## Branch

`feature/todo-app-subtasks-1.5`

---

## Files Changed Summary

| File                                                            | Action       | Why                                                              |
| --------------------------------------------------------------- | ------------ | ---------------------------------------------------------------- |
| `lib/features/todos/presentation/screens/add_todo_screen.dart`  | **Created**  | Form screen for creating a new Todo                              |
| `lib/features/todos/presentation/screens/edit_todo_screen.dart` | **Created**  | Form screen for editing/deleting an existing Todo                |
| `lib/features/todos/presentation/widgets/todo_item.dart`        | **Modified** | Added `onEdit: VoidCallback` + trailing edit `IconButton`        |
| `lib/features/todos/presentation/screens/todo_home_screen.dart` | **Modified** | Added FAB + `_navigateToAdd` / `_navigateToEdit` / `_deleteTodo` |
| `test/widget_test.dart`                                         | **Modified** | Updated smoke test to verify FAB and todo list on launch         |

---

## Folder Structure After This Subtask

```text
lib/
├── app/
│   └── app.dart
├── features/
│   └── todos/
│       ├── models/
│       │   └── todo.dart
│       └── presentation/
│           ├── screens/
│           │   ├── todo_home_screen.dart     ← MODIFIED
│           │   ├── add_todo_screen.dart      ← NEW
│           │   └── edit_todo_screen.dart     ← NEW
│           └── widgets/
│               └── todo_item.dart            ← MODIFIED
└── main.dart
```

---

## Key New Concepts

### Navigator — The Flutter Navigation Stack

Flutter maintains a stack of screens (routes).

```text
Initial state:
  [TodoHomeScreen]

After tapping +FAB:
  [TodoHomeScreen, AddTodoScreen]   ← AddTodoScreen is on top

After pressing back / saving:
  [TodoHomeScreen]                  ← AddTodoScreen popped off
```

**.NET Parallel:**

- `Navigator.push` → `NavigationService.NavigateTo()` in MAUI / `Response.Redirect()` in ASP.NET
- `Navigator.pop` → navigating back, like the browser back button or closing a dialog

---

### Navigator.push — Navigate Forward

```dart
final result = await Navigator.push<Todo>(
  context,
  MaterialPageRoute(builder: (context) => const AddTodoScreen()),
);
```

- `<Todo>` — the return type we expect from the pushed screen
- `MaterialPageRoute` — standard slide-in transition
- `builder:` — creates the screen widget when needed
- Returns a `Future<Todo?>` — resolves when the user navigates back

---

### Navigator.pop — Navigate Back (with optional result)

```dart
// In AddTodoScreen — pop and send the new todo back
Navigator.pop(context, newTodo);

// In any screen — pop without a result (pressed back)
Navigator.pop(context);
```

The caller receives whatever was passed to `pop()` as the awaited result.

**.NET Parallel:**

```csharp
// Like closing a dialog and returning a result:
var dialog = new AddTodoDialog();
dialog.ShowDialog();
var result = dialog.NewTodo; // the returned value
```

---

### async / await with Navigation

Navigation is asynchronous — you `await` the push, and your code resumes when the user comes back.

```dart
Future<void> _navigateToAdd() async {
  final newTodo = await Navigator.push<Todo>(context, ...);
  // code here runs AFTER the user returns from AddTodoScreen
  if (!mounted) return; // safety check
  if (newTodo != null) {
    setState(() { _todos = [..._todos, newTodo]; });
  }
}
```

**.NET Parallel:**

```csharp
var result = await dialogService.ShowDialogAsync<AddTodoDialog>();
if (result != null) { todos.Add(result); }
```

---

### The `mounted` Check — Critical Safety Rule

After any `await`, the widget might have been removed from the tree. Always check `mounted` before calling `setState()` or using `context` after an `await`:

```dart
final result = await Navigator.push(...);
if (!mounted) return;  // ← guard against disposed widget
setState(() { ... });
```

Without this, you get: `setState() called after dispose()` — a runtime error.

**.NET Parallel:** Checking `IsDisposed` or `CancellationToken.IsCancellationRequested` before using a resource after an async gap.

---

### TextEditingController — Reading TextField Input

```dart
final _titleController = TextEditingController();

// In the TextField:
TextField(controller: _titleController)

// Read the value:
String title = _titleController.text.trim();
```

Must be disposed in `dispose()`:

```dart
@override
void dispose() {
  _titleController.dispose();
  super.dispose();
}
```

**.NET Parallel:** Like data-binding a TextBox to a ViewModel property, but with manual lifecycle management.

---

### initState() — Pre-filling the Edit Form

`EditTodoScreen` needs to pre-fill the form with the existing todo's values. This happens in `initState()`:

```dart
@override
void initState() {
  super.initState(); // always first
  _titleController = TextEditingController(text: widget.todo.title);
  _descriptionController = TextEditingController(text: widget.todo.description);
  _selectedPriority = widget.todo.priority;
}
```

`widget.todo` accesses the `todo` passed to `EditTodoScreen`'s constructor.

**Order:** `super.initState()` MUST be called first. It initializes Flutter's internal plumbing.

**.NET Parallel:** The constructor body of a ViewModel that accepts an existing entity.

---

### late final — Deferred Initialization

```dart
late final TextEditingController _titleController;
```

- `late` → will be initialized later (in `initState`, not at field declaration)
- `final` → once assigned, cannot be reassigned
- If you access it before `initState()` runs → runtime error (intentional safeguard)

**.NET Parallel:** A `readonly` field assigned in a constructor rather than at declaration.

---

### Form + GlobalKey<FormState> — Structured Validation

```dart
final _formKey = GlobalKey<FormState>();

// Wrap fields:
Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Required';
        return null; // valid
      },
    ),
  ]),
)

// Trigger validation:
if (_formKey.currentState!.validate()) {
  // all validators returned null → valid
}
```

**.NET Parallel:** `DataAnnotations` + `ModelState.IsValid` in ASP.NET MVC, or `FluentValidation`.

---

### Spread Operator [...list, newItem]

```dart
_todos = [..._todos, newTodo];
```

Creates a new list containing all existing items plus `newTodo`. This is the idiomatic Dart immutable list addition.

**.NET Parallel:**

```csharp
_todos = _todos.Append(newTodo).ToList();
// or: [.. _todos, newTodo]  (C# 12 spread)
```

---

### AlertDialog + showDialog

```dart
showDialog(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: const Text('Delete Todo?'),
    content: const Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
      TextButton(
        onPressed: () {
          Navigator.pop(dialogContext); // close dialog
          widget.onDelete();            // notify parent
          Navigator.pop(context);       // close edit screen
        },
        child: const Text('Delete'),
      ),
    ],
  ),
);
```

Note: using `dialogContext` (not `context`) for the dialog's pop — `context` refers to the edit screen, not the dialog.

**.NET Parallel:** `MessageBox.Show()` in WinForms, `ContentDialog` in WinUI/MAUI.

---

### FloatingActionButton

```dart
floatingActionButton: FloatingActionButton(
  onPressed: _navigateToAdd,
  tooltip: 'Add Todo',
  child: const Icon(Icons.add),
),
```

The primary Material Design action button, floating over content in the bottom-right corner.

Note: `onPressed: _navigateToAdd` — this is a method tear-off. `_navigateToAdd` is a `Future<void> Function()`, which matches what `onPressed` expects.

---

## How to Test in Chrome

### Step 1 — Static analysis

```bash
flutter analyze
```

Expected: `No issues found!` ✅

### Step 2 — Run

```bash
flutter run -d chrome
```

### Step 3 — Verification checklist

- ✅ Home screen shows the 5 mock todos
- ✅ Blue `+` FAB in bottom-right corner
- ✅ Tap `+` → slides to "Add Todo" screen with Title, Description, Priority fields
- ✅ Leave Title empty and tap "Add Todo" → red validation error appears below the field
- ✅ Fill Title, tap "Add Todo" → navigates back, new card appears at bottom of list
- ✅ Tap the pencil icon (✏️) on any card → slides to "Edit Todo" screen, pre-filled
- ✅ Change the title, tap "Save Changes" → card updates on home screen
- ✅ In Edit screen, tap the 🗑 delete icon → confirmation dialog appears
- ✅ Tap Delete → card removed from home screen
- ✅ Delete all todos → empty state message appears

---

## Small Experiments

### Experiment A — Test validation

Open the Add screen. Leave Title empty, tap "Add Todo". A red "Please enter a title" error appears below the field. No navigation occurs.

### Experiment B — See the mounted check in action

(Conceptual) Remove `if (!mounted) return;` from `_navigateToAdd`. In practice it rarely causes issues in simple apps, but understanding why it's there is important.

### Experiment C — Empty state

Delete all 5 mock todos one by one. After the last deletion, the home screen shows: "No todos yet. Tap + to add your first one!" — the empty state message.

---

## Navigation Flow Diagram

```text
TodoHomeScreen
    │
    ├── [FAB tap] → Navigator.push → AddTodoScreen
    │                   │
    │                   ├── [Back button] → Navigator.pop(null) → no change
    │                   └── [Add Todo]   → Navigator.pop(newTodo) → setState adds todo
    │
    └── [Edit icon tap] → Navigator.push → EditTodoScreen(todo)
                            │
                            ├── [Back button]  → Navigator.pop(null) → no change
                            ├── [Save Changes] → Navigator.pop(updatedTodo) → setState updates
                            └── [Delete icon]  → AlertDialog
                                    │
                                    ├── [Cancel] → dismiss dialog only
                                    └── [Delete] → onDelete() + Navigator.pop → setState removes
```

---

## Suggested Git Commit Message

```
feat: add navigation with add/edit todo screens and floating action button
```
