// TodoHomeScreen is the first visible screen of the Todo application.
//
// Responsibility:
//   - Display the main Todo page
//   - Provide a Scaffold (app bar + body structure)
//   - Serve as the landing screen for the MaterialApp
//
// What it does NOT do (yet):
//   - No actual Todo list displayed
//   - No CRUD operations
//   - No state management
//
// Think of this as the "landing page" of the feature.
// Future subtasks will fill in the real Todo content here.

import 'package:flutter/material.dart';

// StatelessWidget is used here because this screen has no
// internal state that changes over time. It simply describes
// a fixed UI based on its configuration.
//
// .NET Parallel: Imagine this as a read-only Page/View with no
// code-behind variables being mutated.
class TodoHomeScreen extends StatelessWidget {
  // The 'const' constructor means Flutter can create this widget at
  // compile time — a free performance optimization.
  const TodoHomeScreen({super.key});

  // build() is called by Flutter whenever this widget needs to be drawn.
  // It receives a BuildContext which represents this widget's location
  // in the widget tree — similar to a scoped service provider in .NET DI.
  //
  // The return type is Widget. Everything you see on screen is a Widget.
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the standard visual structure of a Material page:
    //   - appBar  → top navigation bar
    //   - body    → the main content area
    //   - floatingActionButton, drawer, bottomNavigationBar (not used yet)
    //
    // .NET Parallel: Think of Scaffold as a Page template or Shell in
    // .NET MAUI — it gives you a consistent page layout without building it yourself.
    // Note: Scaffold and AppBar do not have const constructors because
    // they have many optional fields with non-const defaults.
    // We apply 'const' only to the individual leaf widgets that support it.
    return Scaffold(
      // AppBar is the horizontal bar across the top of the screen.
      // It displays the page title and can later hold action buttons.
      //
      // .NET Parallel: Similar to a TitleBar or NavigationBar in MAUI/WPF.
      appBar: AppBar(title: const Text('My Todos')),

      // body is the main content area below the AppBar.
      // Center is a layout widget that positions its single child
      // in the exact middle of the available space.
      body: const Center(
        child: Text(
          'Todo application foundation is ready.\nTodo list coming soon!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
