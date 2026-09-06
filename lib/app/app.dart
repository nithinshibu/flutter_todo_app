// TodoApp is the root widget of the entire application.
//
// Responsibility:
//   - Own the MaterialApp configuration
//   - Set the application title
//   - Point MaterialApp to the first screen (TodoHomeScreen)
//
// What it does NOT own:
//   - No Todo business logic
//   - No state management
//   - No large UI trees
//
// Why is this separated from main.dart?
//   main.dart's only job is to start the Flutter engine and hand it
//   a widget. All app-level decisions (theme, routing, locale) belong
//   here, not in main.dart. This separation keeps each file focused
//   on a single responsibility — exactly like Program.cs vs Startup.cs
//   in older ASP.NET Core, or the minimal API builder pattern.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/presentation/screens/todo_home_screen.dart';

// StatelessWidget: TodoApp itself never changes. It is a fixed
// configuration object that wires MaterialApp to our first screen.
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the top-level Flutter widget provided by the
    // Material Design library. It sets up:
    //   - Theming (colors, typography, component styles)
    //   - Navigation/routing infrastructure
    //   - Locale and text direction
    //   - Debug banner (hidden in release builds)
    //
    // .NET Parallel: Think of MaterialApp like the WebApplication host
    // builder — it configures the container and pipeline, then hands
    // off to the actual pages.
    return MaterialApp(
      // title: The application name shown in the OS task switcher /
      // browser tab. This is NOT what appears on the AppBar — that is
      // controlled inside each screen.
      title: 'Todo App',

      // debugShowCheckedModeBanner: Hides the red "DEBUG" ribbon in
      // the top-right corner. Helps keep the UI clean while learning.
      debugShowCheckedModeBanner: false,

      // theme: Global Material 3 theme applied to all screens.
      // useMaterial3: true opts into the latest Material Design spec.
      // colorSchemeSeed picks a base color; Flutter generates the full
      // color palette automatically.
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),

      // home: The default screen shown when the app launches.
      // This is the widget displayed at the root of the navigation stack.
      home: const TodoHomeScreen(),
    );
  }
}
