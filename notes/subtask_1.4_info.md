# Subtask 1.4 — Info: Make Todos Interactive

## Branch

`feature/todo-app-subtasks-1.4` (or continued on current branch)

---

## Files Changed Summary

| File                                                            | Action       | Why                                                                 |
| --------------------------------------------------------------- | ------------ | ------------------------------------------------------------------- |
| `lib/features/todos/models/todo.dart`                           | **Modified** | Added `copyWith()` method for immutable updates                     |
| `lib/features/todos/presentation/widgets/todo_item.dart`        | **Modified** | Added `onToggle` callback + `InkWell` tap handler                   |
| `lib/features/todos/presentation/screens/todo_home_screen.dart` | **Modified** | Converted to `StatefulWidget`, added `_toggleTodo()` + `setState()` |

---

## The Big New Concept: StatefulWidget vs StatelessWidget

### When to use StatelessWidget

Use `StatelessWidget` when the widget's output depends ONLY on its constructor parameters — it never changes on its own.

```dart
// The title is fixed — this widget never needs to rebuild itself
class AppBar extends StatelessWidget {
  final String title;
  ...
}
```

**.NET Parallel:** A read-only Razor Page / ViewModel with no mutable properties.

### When to use StatefulWidget

Use `StatefulWidget` when the widget has data that changes over time and must trigger UI rebuilds.

```dart
// The todos list changes when user taps — needs to rebuild
class TodoHomeScreen extends StatefulWidget { ... }
class _TodoHomeScreenState extends State<TodoHomeScreen> {
  List<Todo> _todos = [...]; // ← mutable state
}
```

**.NET Parallel:** A ViewModel with `INotifyPropertyChanged`, or a Blazor component with `StateHasChanged()`.

---

## The StatefulWidget Two-Class Pattern

Every `StatefulWidget` in Flutter is two classes:

```text
TodoHomeScreen (StatefulWidget)
    - Immutable, like all widgets
    - Only job: call createState()
    - Holds constructor parameters (none here)

_TodoHomeScreenState (State<TodoHomeScreen>)
    - Mutable
    - Owns the _todos list
    - Contains build() method
    - Calling setState() triggers rebuild
```

Why two classes? Flutter can recreate the widget object (TodoHomeScreen) very frequently without losing the state. The State object persists.

**.NET Parallel:**

```text
StatefulWidget ≈ the class declaration
State          ≈ the long-lived instance with observable properties
```

---

## The setState() Flow

```text
User taps a TodoItem card
        ↓
InkWell.onTap fires in TodoItem
        ↓
Calls: onToggle()  (the VoidCallback passed from parent)
        ↓
Calls: () => _toggleTodo(currentTodo.id)  in TodoHomeScreen
        ↓
setState(() { ... }) executes
        ↓
Flutter schedules a rebuild of _TodoHomeScreenState
        ↓
build() runs again with updated _todos list
        ↓
ListView.builder rebuilds the tapped TodoItem
        ↓
Icon changes ○ ↔ ✔, title gains/loses strikethrough
```

---

## The Immutable Update Pattern (copyWith)

Todo's fields are all `final` — you cannot mutate them:

```dart
todo.isCompleted = true; // ← COMPILE ERROR!
```

Instead, we use `copyWith()` to create a NEW Todo with the changed field:

```dart
final updated = todo.copyWith(isCompleted: !todo.isCompleted);
```

The original `todo` is untouched. We replace it in the list.

**.NET Parallel — C# records:**

```csharp
var updated = todo with { IsCompleted = !todo.IsCompleted };
```

`copyWith()` is the manual Dart equivalent of C#'s `with` expression.

---

## The map() + toList() Pattern

Inside `setState()`:

```dart
_todos = _todos.map((todo) {
  if (todo.id == id) {
    return todo.copyWith(isCompleted: !todo.isCompleted);
  }
  return todo;
}).toList();
```

**.NET Parallel (LINQ):**

```csharp
_todos = _todos.Select(t =>
    t.Id == id ? t with { IsCompleted = !t.IsCompleted } : t
).ToList();
```

`map()` is Dart's equivalent of LINQ `Select()`. It returns a lazy `Iterable<Todo>`. `.toList()` forces evaluation into a concrete `List<Todo>`.

---

## The Callback Pattern (onToggle: VoidCallback)

`TodoItem` accepts a callback:

```dart
final VoidCallback onToggle;
```

`TodoHomeScreen` passes a closure that captures the correct `id`:

```dart
onToggle: () => _toggleTodo(currentTodo.id),
```

Why a closure and not just `onToggle: _toggleTodo`?
`_toggleTodo` takes a `String id` argument, but `VoidCallback` is `void Function()` — no arguments. The closure `() => _toggleTodo(currentTodo.id)` bridges this by capturing `currentTodo.id` from the enclosing scope.

**.NET Parallel:**

```csharp
// Blazor: OnToggle="() => ToggleTodo(todo.Id)"
// WPF: Command = new RelayCommand(() => ToggleTodo(todo.Id))
```

---

## Full Interaction Flow Diagram

```
_TodoHomeScreenState
    │
    │  owns
    ▼
List<Todo> _todos
    │
    │  passed item-by-item to
    ▼
TodoItem(todo: ..., onToggle: () => _toggleTodo(id))
    │
    │  user taps → onToggle() fires
    ▼
_toggleTodo(id)
    │
    │  calls
    ▼
setState(() {
  _todos = _todos.map((t) =>
    t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t
  ).toList();
})
    │
    │  Flutter schedules rebuild
    ▼
build() runs → ListView rebuilds affected item
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

- ✅ Same list as Subtask 1.3
- ✅ Tap any incomplete todo (○) → it immediately shows ✔, title gets strikethrough
- ✅ Tap a completed todo (✔) → it toggles back to ○, strikethrough disappears
- ✅ No page reload needed — UI updates instantly (setState + hot rebuild)

---

## Small Experiments

### Experiment A — Toggle multiple todos rapidly

Tap several todos quickly back and forth. Each tap immediately updates the UI. This demonstrates setState() triggering individual rebuilds.

### Experiment B — Check the no-mutation guarantee

In `_toggleTodo`, try changing:

```dart
return todo.copyWith(isCompleted: !todo.isCompleted);
```

to:

```dart
todo.isCompleted = true; // attempt to mutate directly
return todo;
```

The analyzer will immediately show a compile error: `'isCompleted' can't be used as a setter because it's final`. This is the type-safety benefit of immutable models.
Revert the change afterward.

### Experiment C — See the flow without setState

Temporarily remove the `setState(() { ... })` wrapper and just assign directly:

```dart
void _toggleTodo(String id) {
  _todos = _todos.map((todo) {
    if (todo.id == id) return todo.copyWith(isCompleted: !todo.isCompleted);
    return todo;
  }).toList();
  // No setState — the data changes but Flutter doesn't know!
}
```

Tap a todo. Nothing happens on screen — the data changed but Flutter was never told to rebuild. Revert and add `setState()` back to see the difference.

---

## Dart Concepts Summary Table

| Concept            | Where Used              | .NET Parallel                           |
| ------------------ | ----------------------- | --------------------------------------- |
| `StatefulWidget`   | `TodoHomeScreen`        | ViewModel with mutable properties       |
| `State<T>`         | `_TodoHomeScreenState`  | The ViewModel instance itself           |
| `setState(() { })` | `_toggleTodo`           | `PropertyChanged` / `StateHasChanged()` |
| `copyWith()`       | `todo.dart`             | C# `with` expression on records         |
| `VoidCallback`     | `TodoItem.onToggle`     | `Action` delegate in C#                 |
| Closure / lambda   | `() => _toggleTodo(id)` | `() => ToggleTodo(id)` lambda           |
| `.map().toList()`  | `_toggleTodo`           | LINQ `.Select().ToList()`               |
| `InkWell`          | `TodoItem`              | Tappable container with ripple          |

---

## Suggested Git Commit Message

```
feat: make todos interactive with StatefulWidget, setState, and toggle callback
```
