# Flutter & Dart Learning Notes

This document provides a consolidated overview of the Flutter and Dart concepts used in this project, tailored specifically for **.NET / C# developers**.

For detailed, in-depth deep dives, refer to the dedicated topic notes in this folder:

1. **[01_project_structure.md](01_project_structure.md)** — Comprehensive breakdown of every file, folder, and configuration in the Flutter workspace (.NET comparisons).
2. **[02_main_dart_deep_dive.md](02_main_dart_deep_dive.md)** — Line-by-line explanation of `lib/main.dart`, explaining every widget, constructor, and method.
3. **[03_flutter_for_dotnet_developers.md](03_flutter_for_dotnet_developers.md)** — Conceptual guide: Where CSS/styling comes from, how functions/events are wired, `BuildContext`, the Three Trees, and Dart vs C# syntax.

---

## 1. Project Files Summary

- **`pubspec.yaml`**: The project manifest (equivalent to `.csproj` + NuGet configuration). Defines app metadata, Dart SDK version (`^3.13.2`), dependencies (`flutter`, `cupertino_icons`), dev dependencies (`flutter_test`, `flutter_lints`), and asset declarations.
- **`pubspec.lock`**: Exact locked dependency tree (equivalent to `packages.lock.json`).
- **`analysis_options.yaml`**: Linter and analyzer configuration (equivalent to `.editorconfig` / Roslyn analyzer rules).
- **`lib/`**: Where your application Dart code lives (like `src/` in .NET).
- **`lib/main.dart`**: The application entry point containing `main()` and the initial widget tree (like `Program.cs`).
- **`android/` & `windows/`**: Native platform host shells (like platform heads in .NET MAUI).
- **`test/widget_test.dart`**: Automated component/smoke tests for UI widgets.
- **`build/` & `.dart_tool/`**: Intermediate and final build outputs (equivalent to `bin/` and `obj/`).

---

## 2. Anatomy of `lib/main.dart`

The default application is a **Counter App** demonstrating the following core elements:

```text
main() ─────────> runApp(const MyApp())
                         │
                         ▼
             MyApp (StatelessWidget)
             └── MaterialApp (Sets theme & title)
                   └── home: MyHomePage (StatefulWidget)
                                │
                                ▼
                       _MyHomePageState (State)
                       ├── int _counter = 0;
                       ├── void _incrementCounter() { setState(() => _counter++); }
                       └── build(BuildContext)
                             └── Scaffold
                                   ├── AppBar
                                   ├── Body: Center -> Column -> [ Text, Text ]
                                   └── FloatingActionButton (onPressed: _incrementCounter)
```

### Key Takeaways:

1. **`main()` and `runApp()`**: Initializes the Flutter engine and mounts the root widget (`MyApp`) to the screen.
2. **`StatelessWidget` (`MyApp`)**: An immutable widget blueprint. Ideal for components that don't need to retain mutable state across user interactions.
3. **`StatefulWidget` (`MyHomePage`)**: Uses two classes:
   - `MyHomePage`: Holds immutable configuration parameters (`title`).
   - `_MyHomePageState`: Holds mutable runtime state (`_counter`) and rebuilds the UI when state changes.
4. **`setState(() { ... })`**: Flags the widget as "dirty", telling Flutter to re-run `build()` and repaint only the updated elements. Similar to `StateHasChanged()` in Blazor or `INotifyPropertyChanged` in WPF.

---

## 3. Where Does the "CSS" / Styling Come From?

In Flutter, **there are no CSS or XAML files**. All styling is done in Dart code through three levels:

1. **Inline Properties**: `TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)`.
2. **Layout & Decorator Widgets**: Spacing and boxes are widgets (`Padding`, `Container`, `SizedBox`, `Card`). For example, borders, background colors, and shadows are configured via `Container(decoration: BoxDecoration(...))`.
3. **Global Theming (`ThemeData`)**: Declared in `MaterialApp(theme: ThemeData(...))`. Any child can read active theme colors or text styles dynamically using `Theme.of(context)`.

---

## 4. How Functions & Events Are Called

- Dart functions are first-class objects (like `Action` or `Func<T>` in C#).
- **Tear-off / Method Reference**:
  ```dart
  // Pass the method pointer without parentheses:
  FloatingActionButton(
    onPressed: _incrementCounter,
  )
  ```
- **Lambda / Closure**:
  ```dart
  FloatingActionButton(
    onPressed: () {
      _incrementCounter();
    },
  )
  ```
- **Callbacks with Data** (e.g. Checkbox or TextField):
  ```dart
  Checkbox(
    value: isDone,
    onChanged: (bool? val) {
      setState(() => isDone = val ?? false);
    },
  )
  ```

---

## 5. Dart vs C# Quick Reference

- **Variables**: `var` (inferred), `final` (readonly runtime), `const` (compile-time constant).
- **Privacy**: Leading `_` indicates private to the file (e.g., `_counter`, `_MyHomePageState`). There is no `private` keyword.
- **Constructors**: Named parameters using curly braces: `MyHomePage({super.key, required this.title});`.
- **Async**: `Future<T>` = `Task<T>`, `Stream<T>` = `IAsyncEnumerable<T>`, using `async` / `await`.
- **LINQ equivalents**: `.map()` (`.Select()`), `.where()` (`.Where()`), `.toList()` (`.ToList()`).
