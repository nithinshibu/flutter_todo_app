# Subtask 1.6 — Info: Forms and Complete Todo Information

## Branch

`feature/todo-app-subtasks-1.6`

---

## Files Changed Summary

| File                                                            | Action       | Why                                                                                          |
| --------------------------------------------------------------- | ------------ | -------------------------------------------------------------------------------------------- |
| `lib/features/todos/models/todo.dart`                           | **Modified** | Added `TodoCategory` enum, `category` field, `DateTime? dueDate` field, updated `copyWith()` |
| `lib/features/todos/presentation/screens/add_todo_screen.dart`  | **Modified** | Added category dropdown + date picker                                                        |
| `lib/features/todos/presentation/screens/edit_todo_screen.dart` | **Modified** | Pre-fills category/date in `initState()`, updated `copyWith()` call                          |
| `lib/features/todos/presentation/widgets/todo_item.dart`        | **Modified** | Displays category badge + optional due date badge, extracted `_Badge`, introduced `Wrap`     |
| `lib/features/todos/presentation/screens/todo_home_screen.dart` | **Modified** | Updated mock data to include `category` and `dueDate`                                        |

---

## Key New Concepts

### 1. Nullable Types — `DateTime?`

In Dart, every type is non-nullable by default:

```dart
DateTime dueDate;  // MUST have a value — null is a compile error
DateTime? dueDate; // CAN be null — optional
```

Accessing a nullable value requires a null check:

```dart
if (todo.dueDate != null) {
  print(todo.dueDate!);  // '!' asserts "I know this is not null"
}
```

**.NET Parallel:**

```csharp
DateTime? DueDate { get; }  // identical syntax in C#!
// DueDate.HasValue  →  dueDate != null
// DueDate.Value     →  dueDate!
```

---

### 2. The `clearDueDate` Pattern in `copyWith()`

The standard `??` trick doesn't work for nullable fields:

```dart
// PROBLEM: can't distinguish "keep existing" vs "set to null"
dueDate: newDate ?? this.dueDate
// Both cases receive null — ambiguous!
```

Solution — explicit `clearDueDate` flag:

```dart
Todo copyWith({
  DateTime? dueDate,
  bool clearDueDate = false,
}) {
  return Todo(
    dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
  );
}
```

Usage:

```dart
// Set a new date:
todo.copyWith(dueDate: someDate)

// Clear the date:
todo.copyWith(clearDueDate: true)

// Keep existing date (don't pass either):
todo.copyWith(title: 'New title')
```

**.NET Parallel:** C# `with` expressions handle this naturally:
`todo with { DueDate = null }` — explicit null is unambiguous.

---

### 3. `showDatePicker()` — The Date Picker Dialog

```dart
Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );
  if (!mounted) return;  // always check after await
  if (picked != null) {
    setState(() => _selectedDate = picked);
  }
}
```

`showDatePicker` is a built-in Material widget — no extra package needed.
Returns `Future<DateTime?>` — null if the user dismissed without picking.

**.NET Parallel:** `DatePicker` in WinUI / `DatePickerDialog` in Android / `DatePickerFlyout` in MAUI.

---

### 4. Date Formatting Without `intl`

```dart
String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');    // "01", "31"
  final month = date.month.toString().padLeft(2, '0'); // "01", "12"
  return '$day/$month/${date.year}';                  // "06/09/2026"
}
```

`.padLeft(2, '0')` — pads to minimum width with leading zeros.
**.NET Parallel:** `date.ToString("dd/MM/yyyy")`

---

### 5. `Wrap` — The Overflow-Safe Row

```dart
Wrap(
  spacing: 6.0,    // horizontal gap between children
  runSpacing: 4.0, // vertical gap between lines
  children: [
    Badge(...),
    Badge(...),
    if (todo.dueDate != null) Badge(...), // collection-if
  ],
)
```

Unlike `Row`, `Wrap` automatically moves children to the next line when they don't fit horizontally. Perfect for tag/badge rows where count varies.

**.NET Parallel:** `WrapPanel` in WPF, `FlexLayout` in .NET MAUI.

---

### 6. Collection-if — Conditional Items in Lists

Dart allows `if` expressions directly inside list literals:

```dart
children: [
  Badge(label: 'High Priority', ...),
  Badge(label: 'Learning', ...),
  if (todo.dueDate != null)      // conditionally included
    Badge(label: _formatDate(todo.dueDate!), ...),
]
```

If the condition is false, the item is simply not in the list — no `null` in the list, no extra `Column/Visibility` wrapper needed.

**.NET Parallel:** Blazor `@if` blocks, or XAML `Visibility` binding. Collection-if is more concise than either.

---

### 7. Extracting Private Helper Widgets — `_Badge`

Instead of copy-pasting the same Container/BoxDecoration/Text code three times, we extracted it into a private `_Badge` widget:

```dart
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon; // optional
  ...
}
```

Usage:

```dart
_Badge(label: 'High Priority', color: Colors.red.shade700)
_Badge(label: 'Learning', color: Colors.indigo, icon: Icons.school_outlined)
```

The leading `_` makes `_Badge` private to `todo_item.dart`. It cannot be used anywhere else.

**.NET Parallel:** A private helper UserControl / Blazor sub-component.

---

## Visual Layout After This Subtask

Each TodoItem card now looks like:

```text
┌────────────────────────────────────────────────────────┐
│ ○  Learn Flutter                                    ✏  │
│    Understand widgets, layouts, and the widget tree    │
│    [High Priority] [📚 Learning] [📅 13/09/2026]       │
└────────────────────────────────────────────────────────┘
```

Completed todos:

```text
┌────────────────────────────────────────────────────────┐
│ ✔  ~~Understand Widget Composition~~                ✏  │  ← strikethrough
│    Practice combining StatelessWidgets into a real UI  │
│    [Low Priority] [📚 Learning]                        │  ← no date badge
└────────────────────────────────────────────────────────┘
```

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

- ✅ All 5 cards show Priority + Category badges
- ✅ Todos 1, 2, 5 show a date badge (e.g., "13/09/2026")
- ✅ Todos 3, 4 show NO date badge (dueDate is null)
- ✅ Tap `+` FAB → Add screen has 4 fields: Title, Description, Priority, Category, + date picker
- ✅ Tap "Set due date (optional)" → calendar dialog opens
- ✅ Pick a date → button shows the formatted date + "Clear" button appears
- ✅ Tap "Clear" → date resets to "Set due date (optional)"
- ✅ Tap pencil on any card → Edit screen shows pre-filled category and date
- ✅ Clear the date in Edit, save → date badge disappears from the card

---

## Small Experiments

### Experiment A — Add a todo with all fields

Tap +, fill all fields including picking a date and choosing "Work" category.
The new card appears with a blue "Work" badge and a date badge.

### Experiment B — Nullable field display

Find todos 3 and 4 — they have no `dueDate` set (`null`).
Notice they only show 2 badges (Priority + Category), not 3.
This demonstrates the `if (todo.dueDate != null)` collection-if working correctly.

### Experiment C — Clear a due date on edit

Tap the pencil icon on "Learn Flutter" (which has a date set).
On the Edit screen, tap "Clear" next to the date.
Save — the date badge disappears from the card.
This uses `copyWith(clearDueDate: true)`.

---

## Dart Concepts Summary Table

| Concept                   | Where Used                        | .NET Parallel                          |
| ------------------------- | --------------------------------- | -------------------------------------- |
| `DateTime?` nullable type | `Todo.dueDate`                    | `DateTime? DueDate` in C#              |
| Null assertion `!`        | `todo.dueDate!`                   | `DueDate.Value` or `DueDate!`          |
| Null-aware `??`           | `_selectedDate ?? DateTime.now()` | `date ?? DateTime.Now`                 |
| `clearDueDate` bool flag  | `copyWith()`                      | C# `with { DueDate = null }`           |
| `showDatePicker()`        | `_pickDate()`                     | `DatePicker` / modal dialog            |
| `padLeft()`               | `_formatDate()`                   | `ToString("dd")`                       |
| Collection-if             | List literals                     | `@if` in Blazor / `Visibility` in XAML |
| `Wrap` widget             | Badge row                         | `WrapPanel` in WPF                     |
| Private `_Badge` widget   | `todo_item.dart`                  | Private UserControl                    |

---

## Suggested Git Commit Message

```
feat: expand todo model with category and due date, update forms and display
```
