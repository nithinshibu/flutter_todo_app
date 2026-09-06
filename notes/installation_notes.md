# Flutter Setup, Project Creation, and First Application Run

## Overview

This document contains the complete process I followed to:

1. Install and configure Flutter.
2. Set up Flutter in VS Code.
3. Create my first Flutter application.
4. Understand the initial Flutter project structure.
5. Check available devices.
6. Run the default Flutter application successfully in Chrome.

---

# Part 1 — Installing Flutter and Setting Up VS Code

## Prerequisites

Before installing Flutter, I installed:

- Git
- Visual Studio Code

Git is required because Flutter can be downloaded/cloned from its Git repository.

Visual Studio Code is used as the development environment for writing and running Flutter applications.

---

# Step 1 — Install the Flutter Extension in VS Code

Open VS Code and install the Flutter extension.

### Steps

1. Open VS Code.
2. Open the Extensions section.

Shortcut:

```text
Ctrl + Shift + X
```

3. Search for:

```text
Flutter
```

4. Install the Flutter extension from Dart-Code.

The Flutter extension also provides support for Dart development.

## Why is the Flutter Extension Important?

The Flutter extension provides useful features such as:

- Flutter project creation
- Dart support
- Code completion
- Debugging
- Hot Reload
- Hot Restart
- Flutter commands
- Device selection
- Error detection

The Dart extension is also used for Dart language support.

---

# Step 2 — Install Flutter Using VS Code

Open the VS Code Command Palette.

### Shortcut

```text
Ctrl + Shift + P
```

Then search for:

```text
Flutter: New Project
```

VS Code then prompts for the Flutter SDK.

Since Flutter was not already configured, select:

```text
Download SDK
```

---

# Step 3 — Choose the Flutter SDK Installation Location

VS Code displays:

```text
Select Folder for Flutter SDK
```

Choose the location where the Flutter SDK should be installed.

Then select:

```text
Clone Flutter
```

VS Code downloads the Flutter SDK.

During this process, VS Code may display:

```text
Downloading the Flutter SDK.
This may take a few minutes.
```

Flutter takes some time to download because the SDK contains the Flutter framework, Dart SDK, tools, and required development components.

---

# Step 4 — Add Flutter to PATH

After Flutter is downloaded successfully, select:

```text
Add SDK to PATH
```

A successful message should appear:

```text
The Flutter SDK was added to your PATH
```

## What is PATH?

`PATH` is an environment variable used by Windows to locate executable programs.

After Flutter is added to PATH, commands such as:

```bash
flutter
```

can be executed from a terminal without manually navigating to the Flutter SDK folder.

For example:

```bash
flutter --version
```

works because Flutter was added to the system PATH.

---

# Step 5 — Restart VS Code and Terminals

After adding Flutter to PATH:

1. Close all open terminal windows.
2. Restart VS Code.
3. Open a new terminal.

This ensures that the new PATH configuration is loaded.

---

# Step 6 — Verify Flutter Installation

Open a terminal and run:

```bash
flutter --version
```

This verifies that Flutter is installed and available through the terminal.

The command displays information about:

- Flutter version
- Flutter channel
- Dart version
- DevTools version

If this command works successfully, Flutter has been installed correctly.

---

# Part 2 — Creating My First Flutter Project

## Project Goal

I am creating a Flutter Todo application.

The project will initially be used to:

- Learn Dart
- Learn Flutter fundamentals
- Learn Flutter architecture
- Learn state management
- Learn navigation
- Learn local storage
- Learn production-oriented Flutter development practices

The project name is:

```text
todo_app
```

---

# Step 1 — Create a New Flutter Project

Open VS Code.

Open the Command Palette:

```text
Ctrl + Shift + P
```

Search for:

```text
Flutter: New Project
```

---

# Step 2 — Choose the Project Type

VS Code displays several Flutter project templates.

I selected:

```text
Application
```

## Why Application?

I am creating a normal Flutter application.

The available options have different purposes:

### Application

Used for creating a normal Flutter application.

This is the correct option for the Todo application.

### Empty Application

Creates a more minimal Flutter application.

### Module

Used when Flutter needs to be added to an existing Android or iOS application.

### Package

Used for creating reusable Dart or Flutter libraries.

### Plugin

Used for creating reusable Flutter functionality that may include platform-specific native code.

For this project, the correct choice is:

```text
Application
```

---

# Step 3 — Choose the Project Location

The parent folder selected for the project was:

```text
D:\Flutter Projects\Projects
```

VS Code then asked for the project name.

The project name entered was:

```text
todo_app
```

The final project location became:

```text
D:\Flutter Projects\Projects\todo_app
```

---

# Why Use `todo_app` Instead of `TodoApp`?

Dart and Flutter package names generally follow the convention:

```text
lowercase_with_underscores
```

This is called:

```text
snake_case
```

Therefore:

```text
todo_app
```

is preferred over:

```text
TodoApp
```

---

# Step 4 — Select Target Platforms

During project creation, VS Code asked which platforms should be supported.

I selected:

```text
✓ Android
✓ Windows
```

The other platforms were not selected:

```text
✗ iOS
✗ Linux
✗ macOS
✗ Web
```

## Why Android?

Android is an important Flutter mobile development platform.

The Todo application can later be tested on:

- Android Emulator
- Physical Android device

## Why Windows?

Windows allows Flutter applications to run as native Windows desktop applications.

However, building Flutter applications for Windows requires additional Microsoft C++ development tools.

---

# Part 3 — Generated Flutter Project Structure

After creating the project, Flutter generated the following structure:

```text
todo_app/
│
├── .dart_tool/
├── .idea/
├── android/
├── lib/
├── test/
├── windows/
│
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.lock
├── pubspec.yaml
├── README.md
└── todo_app.iml
```

---

# Important Folders

## `lib/`

This is the most important folder for Flutter development.

Most of the Flutter application code will be written here.

Initially, the main entry point is:

```text
lib/main.dart
```

## `android/`

Contains Android-specific configuration and native platform code.

Most Flutter development normally happens inside the `lib/` folder.

The `android/` folder is modified only when Android-specific configuration is required.

## `windows/`

Contains Windows-specific configuration and native code.

## `test/`

Contains automated tests for the Flutter application.

Later, this project can contain:

- Unit tests
- Widget tests

---

# Important Files

## `lib/main.dart`

This is the main entry point of the Flutter application.

Flutter starts the application from this file.

Later, this file will be studied to understand:

- `main()`
- `runApp()`
- Widgets
- `MaterialApp`
- Stateful widgets
- State
- `setState()`
- Widget tree

## `pubspec.yaml`

One of the most important files in a Flutter project.

It is used to configure:

- Project information
- Dependencies
- Flutter packages
- Assets
- Fonts

For example, when packages such as Riverpod are added later, they will be configured here.

## `pubspec.lock`

Contains the exact versions of dependencies currently used by the project.

This file is generally managed automatically by Flutter and Dart.

## `analysis_options.yaml`

Contains static analysis and linting rules.

These rules help maintain good coding practices and identify potential issues.

## `.gitignore`

Specifies files and folders that Git should ignore.

For example, generated files and temporary build files generally should not be committed to source control.

---

# Part 4 — Check Available Flutter Devices

After creating the project, open the VS Code terminal.

### Shortcut

```text
Ctrl + `
```

Then run:

```bash
flutter devices
```

The output showed:

```text
Windows (desktop)
Chrome (web)
Edge (web)
```

This means Flutter can currently run the application on:

- Windows Desktop
- Google Chrome
- Microsoft Edge

---

# Part 5 — Attempt to Run the Application on Windows

I attempted to run the Flutter application using:

```bash
flutter run -d windows
```

Flutter started preparing the Windows build.

However, the following error appeared:

```text
Error: Unable to find suitable Visual Studio toolchain.
```

# Why Did the Windows Build Fail?

It is important to understand the difference between:

```text
Visual Studio Code
```

and:

```text
Visual Studio
```

They are different applications.

## Visual Studio Code

VS Code is used for:

- Writing code
- Editing files
- Debugging
- Running commands
- Flutter development

## Visual Studio

Visual Studio provides additional tools required to build Windows applications, including:

- C++ compiler
- Windows SDK
- C++ build tools

Flutter requires these tools to compile a Windows desktop application.

Therefore, the Windows application could not currently be built.

This does NOT mean Flutter is broken.

Flutter itself is working correctly.

---

# Part 6 — Run the Flutter Application in Chrome

Since Chrome was detected as an available Flutter device, I ran:

```bash
flutter run -d chrome
```

Flutter then:

1. Built the Flutter application for the web.
2. Started the Flutter development server.
3. Opened Google Chrome.
4. Loaded the default Flutter application.

The application opened at a localhost address similar to:

```text
localhost:xxxxx
```

---

# Part 7 — Windows Firewall Permission

When running the Flutter application for the first time, Windows displayed a Firewall dialog related to:

```text
dartvm.exe
```

This is related to the Dart runtime used by Flutter during development.

The permission was allowed so the Flutter development process could communicate properly.

---

# Part 8 — Default Flutter Application

The default Flutter application successfully opened in Google Chrome.

It displayed:

```text
Flutter Demo Home Page

You have pushed the button this many times:

0

                         +
```

When the `+` button is clicked, the counter increases.

For example:

```text
0 → 1 → 2 → 3 → 4
```

---

# First Flutter Concept Observed: State

The counter application demonstrates an important concept called:

```text
State
```

The application contains data that can change.

Initially:

```text
Counter = 0
```

After clicking the button:

```text
Counter = 1
```

Then:

```text
Counter = 2
```

Flutter updates the user interface when the application's state changes.

The implementation of this application is primarily located inside:

```text
lib/main.dart
```

---

# Useful Flutter Commands Learned

## Check Flutter Version

```bash
flutter --version
```

## Check Flutter Environment

```bash
flutter doctor
```

This command checks the Flutter development environment and identifies missing requirements.

## Check Available Devices

```bash
flutter devices
```

## Run the Application on Windows

```bash
flutter run -d windows
```

> Note: This requires the Microsoft Visual Studio C++ toolchain.

## Run the Application in Google Chrome

```bash
flutter run -d chrome
```

---

# Hot Reload and Hot Restart

When running a Flutter application in development mode, Flutter supports fast development features.

## Hot Reload

Hot Reload updates the application while preserving the current application state where possible.

In the terminal, the shortcut is generally:

```text
r
```

## Hot Restart

Hot Restart restarts the Flutter application's Dart state.

In the terminal, the shortcut is generally:

```text
R
```

## Quit the Running Application

To stop the Flutter application:

```text
q
```

Or use:

```text
Ctrl + C
```

in the terminal.

---

# Current Development Status

| Requirement | Status |
|---|---|
| Git | ✅ Installed |
| VS Code | ✅ Installed |
| Flutter Extension | ✅ Installed |
| Dart Support | ✅ Installed |
| Flutter SDK | ✅ Installed |
| Flutter Added to PATH | ✅ Configured |
| Flutter Project | ✅ Created |
| Android Platform | ✅ Added |
| Windows Platform | ✅ Added |
| Chrome | ✅ Working |
| Flutter Web Execution | ✅ Working |
| Windows Execution | ⚠️ Requires Visual Studio C++ Build Tools |
| Android Emulator | ⏳ Not configured yet |

---

# Current Project Location

```text
D:\Flutter Projects\Projects\todo_app
```

---

# Current Working Command

The Flutter application can currently be run successfully using:

```bash
flutter run -d chrome
```

---

# Next Step

The next step is to study the default Flutter application inside:

```text
lib/main.dart
```

The goal is to understand the core Flutter concepts before starting the production-style Todo application.

The main concepts to learn next are:

- `main()`
- `runApp()`
- Widgets
- Widget tree
- `MaterialApp`
- `StatelessWidget`
- `StatefulWidget`
- State
- `setState()`
- `build()`

After understanding these concepts, the default application can gradually be transformed into a production-style Todo application.

---

# Learning Approach

Instead of watching a large number of tutorials, this project will be used as a practical learning environment.

The approach will be:

```text
Learn Concept
     ↓
Understand Why It Exists
     ↓
Implement It
     ↓
Run the Application
     ↓
Experiment With It
     ↓
Document What Was Learned
```

The goal is not just to create a Todo application.

The goal is to use the Todo application to understand the core concepts required to work on real Flutter applications.
