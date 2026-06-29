import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'reminder.dart';

class ReminderVisual extends StatelessWidget {
  const ReminderVisual({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final visualAsset = reminder.visualAsset;

    return Semantics(
      label: reminder.visualDescription ?? reminder.title,
      image: true,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: visualAsset == null || visualAsset.isEmpty
            ? Icon(
                Icons.self_improvement,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              )
            : SvgPicture.asset(
                visualAsset,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
