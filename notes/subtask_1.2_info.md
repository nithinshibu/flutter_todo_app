# Subtask 1.2 — Info: Create the Application Foundation and First Todo Screen

## Branch

`feature/todo-app-subtasks-1.2`

---

## Files Changed Summary

| File                                                            | Action       | Why                                                                                    |
| --------------------------------------------------------------- | ------------ | -------------------------------------------------------------------------------------- |
| `lib/main.dart`                                                 | **Modified** | Replaced the default counter app entry point with a minimal entry that boots `TodoApp` |
| `lib/app/app.dart`                                              | **Created**  | New root widget that owns `MaterialApp` configuration                                  |
| `lib/features/todos/presentation/screens/todo_home_screen.dart` | **Created**  | First Todo screen — Scaffold + AppBar + placeholder body                               |
| `test/widget_test.dart`                                         | **Modified** | Updated the smoke test to reference `TodoApp` instead of the removed `MyApp`           |

---

## What Changed and Why

### `lib/main.dart` — Modified

**Before:** Contained the full default counter app — `MyApp`, `MyHomePage`, `_MyHomePageState`, 120 lines.

**After:** 30 lines. Its only job is to call `runApp(const TodoApp())`.

**Why:** `main.dart` is the Dart entry point — equivalent to `Program.cs`. Its sole responsibility is to boot the Flutter engine. All app configuration and UI belong elsewhere. Keeping it minimal means it will never need to change as the Todo application grows.

```dart
void main() {
  runApp(const TodoApp());
}
```

---

### `lib/app/app.dart` — Created

**Why does this file exist?**

`MaterialApp` is the application-level configuration widget. It configures:

- The app title (shown in the OS task switcher / browser tab)
- The global color theme (Material 3)
- The initial screen (`home: const TodoHomeScreen()`)
- Debug banner visibility

This configuration is not Todo-specific — it belongs at the application level, not inside a feature. Separating it into `app/app.dart` mirrors the clean split in .NET between `Program.cs` (boots the runtime) and your `WebApplicationBuilder` / startup configuration.

**Key concepts introduced:**

- `StatelessWidget` — used because `TodoApp` never changes. It has no internal state.
- `build(BuildContext context)` — Flutter calls this to describe the UI.
- `MaterialApp` — the root Material Design widget; provides theming and navigation infrastructure.
- `colorSchemeSeed` + `useMaterial3: true` — generates a full color palette from a single seed color using Material 3 design.

---

### `lib/features/todos/presentation/screens/todo_home_screen.dart` — Created

**Why this folder path?**

We are adopting a **feature-first architecture**, which means each feature owns its own folder:

```
lib/features/<feature-name>/presentation/screens/
```

- `features/` — all business features live here (later: `auth/`, `settings/`, etc.)
- `todos/` — the Todo feature
- `presentation/` — the UI layer of the feature (later: `domain/` and `data/` layers will appear here)
- `screens/` — full-page widgets (vs. `widgets/` for reusable components)

**Why not create `data/` and `domain/` yet?**

Because this subtask has no data. Those layers will be introduced when the application actually needs them — preventing premature, speculative architecture.

**Key concepts introduced:**

- `Scaffold` — provides the standard Material page template (AppBar + body + optional FAB, drawer, etc.)
- `AppBar` — the top navigation bar. `title:` sets the page heading.
- `Center` — a layout widget that positions its single child in the center of available space.
- `const` on leaf widgets — applied where the constructor supports it (`Text`, `Center`) but NOT on `Scaffold` or `AppBar` (they don't have `const` constructors due to many optional fields).

---

### `test/widget_test.dart` — Modified

**Why was this changed?**

The original test referenced `MyApp` (the counter class), which was deleted. The test would have caused a compile error. The test was updated to:

1. Boot `TodoApp`
2. Verify `'My Todos'` appears in the AppBar
3. Verify the placeholder body text is visible

**This is not a test subtask** — the change was a necessary side effect of replacing `MyApp`.

---

## Application Startup Flow After This Subtask

```
Dart runtime
    │
    ▼
main()                          ← lib/main.dart
    │
    ▼
runApp(TodoApp())
    │
    ▼
TodoApp.build()                 ← lib/app/app.dart
    │
    ▼
MaterialApp(home: TodoHomeScreen())
    │
    ▼
TodoHomeScreen.build()          ← lib/features/todos/presentation/screens/todo_home_screen.dart
    │
    ▼
Scaffold
    ├── AppBar(title: Text('My Todos'))
    └── body: Center(child: Text('Todo application foundation is ready...'))
```

---

## Widget Tree

```
TodoApp
└── MaterialApp
    └── TodoHomeScreen
        └── Scaffold
            ├── AppBar
            │   └── Text('My Todos')
            └── Center
                └── Text('Todo application foundation is ready...')
```

---

## How to Test in Chrome

### Step 1 — Static analysis (no browser needed)

```bash
flutter analyze
```

Expected output: `No issues found!`

---

### Step 2 — Run in Chrome

```bash
flutter run -d chrome
```

**What you should see:**

- A Chrome window opens
- A clean white page with an indigo-colored AppBar
- AppBar title: **"My Todos"**
- Centered placeholder text: `Todo application foundation is ready. Todo list coming soon!`
- No counter, no floating action button, no debug banner

---

### Step 3 — Quick Hot Reload Experiment (while the app is running)

1. Open `lib/app/app.dart`
2. Change `colorSchemeSeed: Colors.indigo` to `colorSchemeSeed: Colors.teal`
3. Save the file — Flutter will hot-reload instantly
4. The AppBar color will change to a teal theme with **no restart**
5. Change it back to `Colors.indigo` and save

This shows that `ThemeData` changes are reflected immediately during development.

---

## Flutter Concepts Summary Table

| Concept               | File Where Used                     | .NET Parallel                                                  |
| --------------------- | ----------------------------------- | -------------------------------------------------------------- |
| `main()`              | `main.dart`                         | `static void Main()` in Program.cs                             |
| `runApp()`            | `main.dart`                         | `app.Run()` in Program.cs                                      |
| `StatelessWidget`     | `app.dart`, `todo_home_screen.dart` | Read-only ViewModel / Page with no mutable state               |
| `build(BuildContext)` | Both widgets                        | Razor page `OnGet()` / Blazor `BuildRenderTree()`              |
| `MaterialApp`         | `app.dart`                          | `WebApplication` host builder / MAUI app config                |
| `Scaffold`            | `todo_home_screen.dart`             | Page Shell / ContentPage in MAUI                               |
| `AppBar`              | `todo_home_screen.dart`             | TitleBar / NavigationBar in MAUI/WPF                           |
| `const` on widgets    | Both                                | `readonly` / `static readonly` — compile-time allocation       |
| `BuildContext`        | Both                                | `IServiceProvider` scoped to the widget's position in the tree |

---

## Suggested Git Commit Message

```
feat: create todo application foundation with TodoApp and TodoHomeScreen
```
