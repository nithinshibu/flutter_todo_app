// main.dart — The Flutter application entry point.
//
// Responsibility:
//   - One job only: start the Flutter engine and hand it the root widget.
//
// What it does NOT contain:
//   - No UI widgets
//   - No business logic
//   - No screens or navigation
//
// .NET Parallel:
//   This file is the equivalent of Program.cs in a .NET application.
//   Its only purpose is to boot the runtime and hand off to the application.
//
//   .NET:    var app = builder.Build(); app.Run();
//   Flutter: runApp(const TodoApp());

import 'package:flutter/material.dart';
import 'package:todo_app/app/app.dart';

// main() is the Dart application entry point.
//
// Every Dart program — including a Flutter app — starts here.
// Dart finds this function by name, exactly like C# looks for
// static void Main(string[] args) in Program.cs.
//
// The 'void' return type means this function returns nothing.
void main() {
  // runApp() is a Flutter framework function (imported from flutter/material.dart).
  //
  // It does two things:
  //   1. Takes your root widget and attaches it to the screen.
  //   2. Starts the Flutter rendering engine (the widget tree pump).
  //
  // After this call, Flutter takes over. It calls build() on TodoApp,
  // which returns MaterialApp, which displays TodoHomeScreen.
  //
  // 'const' here means TodoApp is created at compile time, not at runtime.
  // This is safe because TodoApp has no runtime-variable constructor arguments.
  runApp(const TodoApp());
}
