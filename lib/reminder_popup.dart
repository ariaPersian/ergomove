import 'package:flutter/material.dart';

import 'reminder.dart';
import 'reminder_art.dart';
import 'reminder_guidance.dart';

class ReminderPopup extends StatelessWidget {
  const ReminderPopup({
    super.key,
    required this.reminder,
    required this.language,
    required this.onDismiss,
  });

  final Reminder reminder;
  final ReminderLanguage language;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = language.isRtl;

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(24),
      color: colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isRtl ? 'یادآور ارگوموو' : 'ErgoMove reminder',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: isRtl ? 'بستن' : 'Dismiss',
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ReminderArt(reminder: reminder, height: 150),
                const SizedBox(height: 16),
                Text(
                  reminder.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ReminderGuidance(
                  reminder: reminder,
                  language: language,
                  compact: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
