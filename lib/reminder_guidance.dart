import 'package:flutter/material.dart';

import 'reminder.dart';

class ReminderGuidance extends StatelessWidget {
  const ReminderGuidance({
    super.key,
    required this.reminder,
    required this.language,
    this.compact = false,
  });

  final Reminder reminder;
  final ReminderLanguage language;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final doseLabel = reminder.doseLabel?.trim() ?? '';
    final steps = reminder.instructionSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reminder.body,
          style: compact
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context).textTheme.bodyLarge,
        ),
        if (doseLabel.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    doseLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (steps.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            language.isRtl ? 'روش انجام' : 'How to do it',
            style: compact
                ? Theme.of(context).textTheme.labelLarge
                : Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < steps.length; index++) ...[
            _InstructionStep(
              number: index + 1,
              text: steps[index],
              compact: compact,
            ),
            if (index != steps.length - 1)
              SizedBox(height: compact ? 6 : 8),
          ],
        ],
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reminder.safetyNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({
    required this.number,
    required this.text,
    required this.compact,
  });

  final int number;
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: compact ? 22 : 24,
          height: compact ? 22 : 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: compact
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
