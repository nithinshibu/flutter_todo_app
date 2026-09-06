# Flutter Learning Notes (For .NET Developers)

Welcome to your offline learning hub for Flutter and Dart!

Because you are coming from a **.NET / C# background**, you already have strong foundations in OOP, static typing, asynchronous programming, and clean architecture. Rather than spending hours watching long video tutorials, these notes are tailored to map Flutter and Dart directly to concepts you already know.

---

## Documentation Index

| File                                                                            | Topic                              | Description                                                                                                                                                                                 |
| ------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 📄 [`installation_notes.md`](installation_notes.md)                             | **Setup & Run History**            | Step-by-step log of Flutter SDK installation, VS Code setup, platforms added, and first Chrome run.                                                                                         |
| 📄 [`01_project_structure.md`](01_project_structure.md)                         | **File & Folder Breakdown**        | Explains every root file and folder (`pubspec.yaml`, `analysis_options.yaml`, `lib/`, `android/`, `windows/`, `.dart_tool/`), compared side-by-side with .NET (`csproj`, NuGet, `bin/obj`). |
| 📄 [`02_main_dart_deep_dive.md`](02_main_dart_deep_dive.md)                     | **`lib/main.dart` Walkthrough**    | Line-by-line breakdown of the initial counter app: `main()`, `runApp()`, `StatelessWidget`, `StatefulWidget`, `State`, `setState()`, `Scaffold`, and widget composition.                    |
| 📄 [`03_flutter_for_dotnet_developers.md`](03_flutter_for_dotnet_developers.md) | **Rosetta Stone (.NET ↔ Flutter)** | Direct answers to: Where does "CSS" come from? How are functions/events invoked? What is `BuildContext`? Declarative UI vs Imperative, and Dart vs C# syntax cheat sheet.                   |

---

## Recommended Reading Order

```text
Step 1: Understand the workspace & files
        └── Read: 01_project_structure.md
                │
Step 2: Understand the startup code & anatomy of main.dart
        └── Read: 02_main_dart_deep_dive.md
                │
Step 3: Master the paradigms (Styling, Events, BuildContext, C# vs Dart)
        └── Read: 03_flutter_for_dotnet_developers.md
                │
Step 4: Transition the project into the Todo Application
        └── Ready for coding!
```

---

## Quick Reference Summary

| .NET / C# Concept                                         | Flutter / Dart Equivalent                                              |
| --------------------------------------------------------- | ---------------------------------------------------------------------- |
| `todo_app.csproj`                                         | `pubspec.yaml`                                                         |
| NuGet packages (`nuget.org`)                              | Pub packages (`pub.dev`)                                               |
| `Program.cs` (`Main()`)                                   | `lib/main.dart` (`main()`)                                             |
| `app.Run()`                                               | `runApp(const MyApp())`                                                |
| Imperative UI (`label.Text = "..."`)                      | Declarative UI ($UI = f(State)$ via `setState()`)                      |
| Blazor `StateHasChanged()` / WPF `INotifyPropertyChanged` | `setState(() { ... })`                                                 |
| `IServiceProvider` / Ambient Context                      | `BuildContext` (`Theme.of(context)`, `MediaQuery.of(context)`)         |
| CSS / XAML Styling                                        | In-code widgets (`ThemeData`, `TextStyle`, `BoxDecoration`, `Padding`) |
| Delegates / Events (`button.Click += ...`)                | First-class functions / callbacks (`onPressed: _incrementCounter`)     |
| `private` keyword                                         | Leading underscore `_` (file-private in Dart)                          |
| `readonly` keyword                                        | `final` keyword                                                        |
| `Task<T>`                                                 | `Future<T>`                                                            |
| `IAsyncEnumerable<T>`                                     | `Stream<T>`                                                            |
| LINQ `.Select().Where().ToList()`                         | `.map().where().toList()`                                              |
