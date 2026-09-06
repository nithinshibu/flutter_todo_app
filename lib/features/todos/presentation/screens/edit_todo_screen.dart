// edit_todo_screen.dart — Screen for editing an existing Todo.
//
// Updated in Subtask 1.6:
//   - Pre-fills category from widget.todo.category in initState()
//   - Pre-fills _selectedDate from widget.todo.dueDate in initState()
//   - Added category dropdown
//   - Added date picker with clear option
//   - Passes updated values to copyWith() including clearDueDate

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;
  final VoidCallback onDelete;

  const EditTodoScreen({super.key, required this.todo, required this.onDelete});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TodoPriority _selectedPriority;
  late TodoCategory _selectedCategory;

  // _selectedDate is nullable — the user may or may not have a date set.
  // We use 'late' (not 'late final') because the user can change it
  // (set a new date or clear it) during editing.
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    _selectedPriority = widget.todo.priority;
    _selectedCategory = widget.todo.category;
    // Pre-fill the date — may be null if no due date was ever set
    _selectedDate = widget.todo.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (!mounted) return;
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = widget.todo.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDate,
        // If _selectedDate is null AND the original had a date,
        // clearDueDate: true tells copyWith to explicitly set dueDate = null.
        // Without this flag, copyWith would keep the original date.
        clearDueDate: _selectedDate == null,
      );
      Navigator.pop(context, updatedTodo);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Todo?'),
        content: Text(
          'Are you sure you want to delete "${widget.todo.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              widget.onDelete();
              Navigator.pop(context);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete this todo',
            onPressed: _confirmDelete,
          ),
        ],
      ),
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

            // ── Description ─────────────────────────────────────────────
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
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
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18.0),
                  label: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Set due date (optional)',
                  ),
                ),
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

            FilledButton(onPressed: _submit, child: const Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
