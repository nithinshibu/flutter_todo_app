// todo_item.dart — A reusable widget that displays ONE Todo item.
//
// Updated in Subtask 1.6:
//   - Added category badge using _categoryLabel() / _categoryColor()
//   - Added due date display with calendar icon (only shown when set)
//   - Replaced separate badge containers with a Wrap layout
//   - Introduced: Wrap widget, collection-if inside lists, null-aware display

import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
  });

  // ── Priority helpers ────────────────────────────────────────────────────

  String _priorityLabel(TodoPriority priority) {
    return switch (priority) {
      TodoPriority.high => 'High Priority',
      TodoPriority.medium => 'Medium Priority',
      TodoPriority.low => 'Low Priority',
    };
  }

  Color _priorityColor(TodoPriority priority) {
    return switch (priority) {
      TodoPriority.high => Colors.red.shade700,
      TodoPriority.medium => Colors.orange.shade700,
      TodoPriority.low => Colors.green.shade700,
    };
  }

  // ── Category helpers ────────────────────────────────────────────────────

  String _categoryLabel(TodoCategory category) {
    return switch (category) {
      TodoCategory.personal => 'Personal',
      TodoCategory.work => 'Work',
      TodoCategory.learning => 'Learning',
      TodoCategory.health => 'Health',
      TodoCategory.shopping => 'Shopping',
    };
  }

  IconData _categoryIcon(TodoCategory category) {
    // Each category gets a meaningful icon for quick visual recognition.
    // Icons class provides hundreds of Material Design icons.
    return switch (category) {
      TodoCategory.personal => Icons.person_outline,
      TodoCategory.work => Icons.work_outline,
      TodoCategory.learning => Icons.school_outlined,
      TodoCategory.health => Icons.favorite_outline,
      TodoCategory.shopping => Icons.shopping_cart_outlined,
    };
  }

  // ── Date helper ─────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // ── build() ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row: Icon + Title + Edit button ──────────────────────
              Row(
                children: [
                  Icon(
                    todo.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: todo.isCompleted ? Colors.green : Colors.grey,
                    size: 22.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted ? Colors.grey : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: 18.0,
                    color: Colors.grey.shade500,
                    tooltip: 'Edit todo',
                    onPressed: onEdit,
                  ),
                ],
              ),

              // ── Description ──────────────────────────────────────────
              if (todo.description.isNotEmpty) ...[
                const SizedBox(height: 6.0),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],

              // ── Tags: Priority + Category + Due Date ─────────────────
              //
              // Wrap is a layout widget that places children in a row,
              // automatically wrapping to the next line when there is not
              // enough horizontal space. Unlike Row, it never overflows.
              //
              // It's perfect for tag/badge displays where the number of
              // items varies (some todos have dates, some don't).
              //
              // .NET Parallel: WrapPanel in WPF, FlexLayout in .NET MAUI.
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Wrap(
                  spacing: 6.0, // horizontal space between children
                  runSpacing: 4.0, // vertical space between rows (when wrapped)
                  children: [
                    // ── Priority badge ────────────────────────────────
                    _Badge(
                      label: _priorityLabel(todo.priority),
                      color: _priorityColor(todo.priority),
                    ),

                    // ── Category badge ────────────────────────────────
                    _Badge(
                      label: _categoryLabel(todo.category),
                      color: Colors.indigo.shade700,
                      icon: _categoryIcon(todo.category),
                    ),

                    // ── Due date (only shown when a date is set) ──────
                    //
                    // Collection-if: conditionally includes a widget in
                    // a list literal. If todo.dueDate is not null, the
                    // _Badge is included; otherwise it is absent entirely.
                    //
                    // .NET Parallel:
                    //   @if (todo.DueDate.HasValue) { <DueDateBadge /> }
                    if (todo.dueDate != null)
                      _Badge(
                        label: _formatDate(todo.dueDate!),
                        // The '!' (null assertion operator) tells Dart:
                        // "I know this isn't null — trust me."
                        // It's safe here because the 'if' above already
                        // checked that dueDate is not null.
                        // .NET Parallel: todo.DueDate!.Value
                        color: Colors.blueGrey.shade600,
                        icon: Icons.calendar_today_outlined,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── _Badge — A private reusable label/chip widget ────────────────────────────
//
// Why extract this as a separate widget?
//   The priority, category, and due date all share the same visual style
//   (colored text on a tinted background). Instead of copying the Container
//   + BoxDecoration + Text code 3 times, we extract it into one small widget.
//
//   This is the core principle of reusable widget composition in Flutter.
//
// The leading underscore makes it private to this file.
// .NET Parallel: A private helper UserControl or a Blazor sub-component.
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon; // optional icon before the label

  const _Badge({
    required this.label,
    required this.color,
    this.icon, // nullable — only some badges have an icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // shrink-wrap the row to its content
        children: [
          // Only include the icon if one was provided (collection-if)
          if (icon != null) ...[
            Icon(icon, size: 11.0, color: color),
            const SizedBox(width: 3.0),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
