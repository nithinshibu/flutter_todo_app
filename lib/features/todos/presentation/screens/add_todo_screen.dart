// add_todo_screen.dart — The screen for creating a new Todo.
//
// Responsibility:
//   - Present a form with fields for the new Todo
//   - Validate the input (title is required)
//   - Return the new Todo to the caller via Navigator.pop
//
// Key concepts introduced in this file:
//   - initState() / dispose() — StatefulWidget lifecycle methods
//   - TextEditingController — controls a TextField
//   - GlobalKey<FormState> — allows programmatic access to the Form
//   - Form + TextFormField — structured input with built-in validation
//   - DropdownButtonFormField — select from a list of options
//   - Navigator.pop(context, result) — navigate back AND pass data to caller
//
// .NET Parallel:
//   This is like a Modal Dialog / Flyout in MAUI or WPF that returns a
//   result when the user clicks OK. The caller awaits the navigation and
//   receives the created object back.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // GlobalKey<FormState> — A unique identifier for this Form widget.
  //
  // It lets us programmatically call:
  //   _formKey.currentState!.validate()  — runs all field validators
  //
  // Think of it like a handle to the form object.
  //
  // .NET Parallel: Like accessing a named control from code-behind in WPF:
  //   myForm.Validate();
  final _formKey = GlobalKey<FormState>();

  // TextEditingController — Reads and writes the text inside a TextField.
  //
  // When the user types in a TextField, the controller holds the current text.
  // You read it with: _titleController.text
  //
  // TextEditingControllers MUST be disposed when the widget is removed from
  // the tree — otherwise they leak memory (they hold listeners internally).
  //
  // .NET Parallel: Like a data-bound property on a ViewModel, or like
  //   reading textBox.Text in WinForms — but with explicit lifecycle management.
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // The selected priority — starts at medium as a sensible default.
  // This is a normal mutable State variable, not a controller.
  TodoPriority _selectedPriority = TodoPriority.medium;

  // ── initState() — Lifecycle Method ────────────────────────────────────────
  //
  // Called ONCE, immediately after the State object is created and
  // before the first build(). Use it for one-time initialization.
  //
  // For AddTodoScreen we don't need it (our controllers start empty).
  // EditTodoScreen will use initState() to pre-fill the fields.
  //
  // .NET Parallel: Like the constructor of a ViewModel, or OnInitialized()
  //   in a Blazor component.
  //
  // (Not overriding initState here — included as a comment for teaching.)

  // ── dispose() — Lifecycle Method ──────────────────────────────────────────
  //
  // Called when this State object is permanently removed from the tree
  // (i.e., when the user navigates back from this screen).
  //
  // ALWAYS dispose your controllers here.
  // If you forget, the controllers keep listening to keyboard events and
  // holding references even after the screen is gone — a memory leak.
  //
  // Rule: For every controller you create, there must be a dispose() call.
  //
  // .NET Parallel: IDisposable.Dispose() in C# — cleanup resources.
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose(); // Always call super.dispose() last
  }

  // _submit() — Validates the form and pops back with the new Todo.
  //
  // Navigator.pop(context, result) does two things:
  //   1. Removes this screen from the navigation stack (goes back)
  //   2. Passes 'result' back to the caller that pushed this screen
  //
  // The caller (TodoHomeScreen) awaits the navigation push and receives
  // the Todo object here.
  //
  // .NET Parallel:
  //   dialog.ShowDialog() returns DialogResult.OK, and the caller reads
  //   dialog.ResultValue. In Flutter, pop carries the value directly.
  void _submit() {
    // _formKey.currentState!.validate() calls the 'validator' function
    // on every TextFormField inside the Form.
    // Returns true only if ALL validators return null (no error).
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        // Generate a temporary unique ID using the current timestamp.
        // In a real app this would come from a database auto-increment
        // or a UUID package. For now, milliseconds since epoch is unique enough.
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text
            .trim(), // .trim() removes leading/trailing whitespace
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        isCompleted: false,
      );

      // Pop back to TodoHomeScreen and pass the new Todo as the result.
      Navigator.pop(context, newTodo);
    }
    // If validate() returns false, the fields automatically show
    // their error messages — no extra code needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),

      // Use a Form widget to group all TextFormFields together.
      // Form provides the validation infrastructure — it connects
      // all child TextFormFields to a single _formKey.
      body: Form(
        key: _formKey,

        // ListView instead of Column here so the keyboard doesn't
        // cause an overflow when it appears on small screens.
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // TextFormField = TextField + validation support.
            //
            // 'validator' is called when _formKey.currentState!.validate() runs.
            // Return a non-null String to show an error message.
            // Return null to indicate the value is valid.
            //
            // .NET Parallel: DataAnnotation validation like [Required] on a model,
            //   or FluentValidation rules.
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
              ),
              autofocus: true, // keyboard opens automatically
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title'; // error message shown below field
                }
                return null; // valid
              },
            ),

            const SizedBox(height: 16.0),

            // Description is optional — no validator needed.
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add some details (optional)',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3, // allows multi-line input
            ),

            const SizedBox(height: 16.0),

            // DropdownButtonFormField — a dropdown list that integrates
            // with Form validation like TextFormField does.
            //
            // 'value' is the currently selected item.
            // 'items' is the list of selectable options.
            // 'onChanged' fires when the user picks a different item.
            //
            // .NET Parallel: ComboBox in WPF/MAUI, <select> in Blazor.
            DropdownButtonFormField<TodoPriority>(
              initialValue: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: TodoPriority.high, child: Text('High')),
                DropdownMenuItem(
                  value: TodoPriority.medium,
                  child: Text('Medium'),
                ),
                DropdownMenuItem(value: TodoPriority.low, child: Text('Low')),
              ],
              onChanged: (value) {
                if (value != null) {
                  // setState to rebuild the dropdown showing the new selection
                  setState(() => _selectedPriority = value);
                }
              },
            ),

            const SizedBox(height: 24.0),

            // FilledButton is the Material 3 primary action button style.
            // It has a solid background (the theme's primary color).
            FilledButton(onPressed: _submit, child: const Text('Add Todo')),
          ],
        ),
      ),
    );
  }
}
