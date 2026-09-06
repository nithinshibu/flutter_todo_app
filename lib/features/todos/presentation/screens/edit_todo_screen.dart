// edit_todo_screen.dart — The screen for editing an existing Todo.
//
// Responsibility:
//   - Receive an existing Todo via its constructor
//   - Pre-fill the form with that Todo's current values
//   - Allow the user to modify title, description, and priority
//   - Return the updated Todo to the caller on save
//   - Allow the user to delete the Todo (via onDelete callback)
//
// Key new concepts vs AddTodoScreen:
//   - Receiving constructor parameters in a StatefulWidget (widget.todo)
//   - initState() — pre-filling controllers with existing data
//   - 'late final' — declaring a variable that will be assigned in initState
//   - Passing VoidCallback for delete — parent handles state, not this screen
//   - AlertDialog + showDialog — confirmation dialogs
//   - AppBar actions — icon buttons in the top-right of the AppBar
//
// .NET Parallel:
//   Like opening an Edit dialog pre-populated with an existing record.
//   Similar to navigating to a detail/edit page in ASP.NET MVC:
//   GET /todos/edit/{id} → prefill form → POST → redirect back.

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class EditTodoScreen extends StatefulWidget {
  // The Todo being edited — passed in from TodoHomeScreen.
  // Since StatefulWidget is immutable, this is a final field on the widget.
  // The State class accesses it via: widget.todo
  final Todo todo;

  // onDelete — A callback provided by the parent (TodoHomeScreen).
  // When the user confirms deletion, this function is called.
  //
  // WHY a callback instead of handling delete here?
  //   EditTodoScreen does NOT own the _todos list.
  //   Only _TodoHomeScreenState owns it and knows how to remove a todo.
  //   This is the same callback/delegation principle from Subtask 1.4.
  //
  // .NET Parallel:
  //   Like an EventCallback<string> in Blazor:
  //   [Parameter] public EventCallback OnDelete { get; set; }
  final VoidCallback onDelete;

  const EditTodoScreen({super.key, required this.todo, required this.onDelete});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  // 'late final' means:
  //   'late'  → this variable will be initialized AFTER declaration
  //              (in initState, not at field declaration time)
  //   'final' → once assigned, it cannot be reassigned
  //
  // Why 'late' and not just initialize at declaration?
  //   Because we need 'widget.todo.title' to pre-fill the controller.
  //   But 'widget' is only available once the State is attached to its widget,
  //   which happens in initState() — NOT at field declaration time.
  //
  // .NET Parallel: Like a property that's initialized in a constructor
  //   body rather than at the declaration: private readonly TextBox _titleBox;
  //   then in the constructor: _titleBox = new TextBox { Text = todo.Title };
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  // Priority CAN be declared with an initial value here using 'late'
  // because we set it in initState. But we use late to keep it consistent.
  late TodoPriority _selectedPriority;

  // ── initState() ─────────────────────────────────────────────────────────
  //
  // Called ONCE when this State object is first created.
  // Perfect for:
  //   - Pre-filling TextEditingControllers with existing data
  //   - Starting animations
  //   - Subscribing to streams or listeners
  //
  // IMPORTANT: Always call super.initState() FIRST.
  //   It initializes the internal Flutter plumbing before your code runs.
  //
  // .NET Parallel: Like OnInitialized() in Blazor, or the constructor
  //   body in an MVVM ViewModel that pre-loads existing values.
  @override
  void initState() {
    super.initState(); // Always first

    // Pre-fill the controllers with the existing Todo's values.
    // 'widget' is a property of State<T> that gives access to the
    // widget's constructor parameters.
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    _selectedPriority = widget.todo.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // _submit() — Saves the updated Todo and navigates back.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Use copyWith() to create an updated Todo.
      // We preserve the original id and isCompleted — only the fields
      // the user can edit are changed.
      final updatedTodo = widget.todo.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
      );

      // Pop back and return the updated Todo to the caller.
      Navigator.pop(context, updatedTodo);
    }
  }

  // _confirmDelete() — Shows a confirmation dialog before deleting.
  //
  // showDialog() is a Flutter function that overlays an AlertDialog
  // on top of the current screen. It is asynchronous — it resolves
  // when the dialog is dismissed.
  //
  // AlertDialog is a standard Material dialog with:
  //   title   → the heading
  //   content → the body text
  //   actions → the buttons (typically Cancel + Confirm)
  //
  // .NET Parallel:
  //   MessageBox.Show("Are you sure?", "Delete", MessageBoxButtons.YesNo)
  //   in WinForms, or ContentDialog in WinUI/MAUI.
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Todo?'),
        content: Text(
          'Are you sure you want to delete "${widget.todo.title}"?',
        ),
        actions: [
          // TextButton is the low-emphasis button style (no fill, no border).
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext), // dismiss dialog only
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // 1. Close the dialog
              widget.onDelete(); // 2. Tell the parent to remove from list
              Navigator.pop(context); // 3. Pop the edit screen itself
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),

        // actions: a list of widgets displayed on the RIGHT side of the AppBar.
        // Typically used for icon buttons like search, settings, delete, etc.
        //
        // .NET Parallel: ToolBarTray items in WPF, or NavigationPage.TitleView
        //   action buttons in .NET MAUI.
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete this todo',
            onPressed: _confirmDelete,
          ),
        ],
      ),

      // Same form structure as AddTodoScreen — title, description, priority.
      // The key difference: controllers are pre-filled via initState().
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),

            const SizedBox(height: 16.0),

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
                  setState(() => _selectedPriority = value);
                }
              },
            ),

            const SizedBox(height: 24.0),

            FilledButton(onPressed: _submit, child: const Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
