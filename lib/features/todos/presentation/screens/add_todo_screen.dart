// add_todo_screen.dart — Screen for creating a new Todo.
//
// Updated in Subtask 1.6:
//   - Added category DropdownButtonFormField
//   - Added date picker (showDatePicker) for optional due date
//   - Introduced: showDatePicker, DateTime, DateTime?, date formatting
//   - Introduced: Wrap widget (used in form layout)

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TodoPriority _selectedPriority = TodoPriority.medium;
  TodoCategory _selectedCategory = TodoCategory.personal;

  // _selectedDate — The optional due date chosen by the user.
  //
  // DateTime? means this variable can hold:
  //   - A DateTime object (user picked a date)
  //   - null (user hasn't picked a date — the default)
  //
  // .NET Parallel: DateTime? DueDate { get; set; } = null;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // _pickDate() — Opens the system date picker dialog.
  //
  // showDatePicker() is a built-in Flutter function that displays
  // the platform's native date picker UI (Material calendar dialog).
  //
  // It returns a Future<DateTime?> — the picked date, or null if
  // the user dismissed the dialog without selecting.
  //
  // .NET Parallel:
  //   var picker = new DatePicker();
  //   picker.ShowAsync();  // WinUI DatePickerFlyout
  //   or DateTimePickerDialog in Android
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: what's selected when the calendar opens
      initialDate: _selectedDate ?? DateTime.now(),
      // firstDate: earliest selectable date (5 years ago)
      firstDate: DateTime(DateTime.now().year - 5),
      // lastDate: latest selectable date (5 years from now)
      lastDate: DateTime(DateTime.now().year + 5),
    );

    // Always check 'mounted' after any await — especially important here
    // because the user could navigate back while the date picker is open.
    if (!mounted) return;

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // _formatDate() — Formats a DateTime into a readable string.
  //
  // Flutter does not include a date formatting library by default.
  // We use manual string formatting for now (padLeft adds leading zeros).
  // In larger projects, the 'intl' package provides locale-aware formatting.
  //
  // .NET Parallel:
  //   date.ToString("dd/MM/yyyy")   or  date.ToShortDateString()
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        isCompleted: false,
        dueDate: _selectedDate, // null if user didn't pick a date
      );
      Navigator.pop(context, newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // ── Title ───────────────────────────────────────────────────
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0),

            // ── Description ─────────────────────────────────────────────
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add some details...',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),

            const SizedBox(height: 16.0),

            // ── Priority ─────────────────────────────────────────────────
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
                if (value != null) setState(() => _selectedPriority = value);
              },
            ),

            const SizedBox(height: 16.0),

            // ── Category ─────────────────────────────────────────────────
            DropdownButtonFormField<TodoCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TodoCategory.personal,
                  child: Text('Personal'),
                ),
                DropdownMenuItem(value: TodoCategory.work, child: Text('Work')),
                DropdownMenuItem(
                  value: TodoCategory.learning,
                  child: Text('Learning'),
                ),
                DropdownMenuItem(
                  value: TodoCategory.health,
                  child: Text('Health'),
                ),
                DropdownMenuItem(
                  value: TodoCategory.shopping,
                  child: Text('Shopping'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),

            const SizedBox(height: 16.0),

            // ── Due Date ─────────────────────────────────────────────────
            //
            // We use a Row containing:
            //   - OutlinedButton.icon: opens the date picker
            //   - TextButton: clears the date (only shown when a date is set)
            //
            // Why a button and not a TextFormField for dates?
            //   TextFormField expects keyboard input. Dates are best picked
            //   from a calendar — so we use a button that triggers showDatePicker.
            Row(
              children: [
                // OutlinedButton.icon — a button with both an icon and a label.
                // The icon changes based on whether a date is selected.
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18.0),
                  label: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!) // show the date
                        : 'Set due date (optional)', // placeholder
                  ),
                ),

                // Only show the Clear button if a date is actually selected.
                // This is collection-if in Dart:
                //   if (condition) widgetToInclude
                // It conditionally includes a widget in the list.
                //
                // .NET Parallel:
                //   Visibility="{Binding HasDueDate}" in XAML
                //   or conditional rendering in Blazor: @if (hasDueDate) { ... }
                if (_selectedDate != null) ...[
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () => setState(() => _selectedDate = null),
                    child: const Text('Clear'),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24.0),

            FilledButton(onPressed: _submit, child: const Text('Add Todo')),
          ],
        ),
      ),
    );
  }
}
