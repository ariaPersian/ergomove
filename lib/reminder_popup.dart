import 'package:flutter/material.dart';

import 'reminder.dart';
import 'reminder_art.dart';

class ReminderPopup extends StatelessWidget {
  const ReminderPopup({
    super.key,
    required this.reminder,
    required this.onDismiss,
  });

  final Reminder reminder;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(24),
      color: colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ErgoMove reminder',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Dismiss',
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ReminderArt(reminder: reminder),
              const SizedBox(height: 16),
              Text(
                reminder.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(reminder.body),
              const SizedBox(height: 10),
              Text(
                reminder.safetyNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
