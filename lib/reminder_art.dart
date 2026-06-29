import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'reminder.dart';

class ReminderArt extends StatelessWidget {
  const ReminderArt({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final asset = reminder.visualAsset ?? assetForCategory(reminder.category);

    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: asset == null
          ? Icon(
              Icons.self_improvement,
              size: 96,
              color: Theme.of(context).colorScheme.primary,
            )
          : SvgPicture.asset(
              asset,
              fit: BoxFit.contain,
              semanticsLabel: reminder.visualDescription ?? reminder.title,
            ),
    );
  }

  String? assetForCategory(String category) {
    return switch (category) {
      'eyes' => 'assets/images/eye_break.svg',
      'posture' => 'assets/images/posture_reset.svg',
      'movement' => 'assets/images/movement_walk.svg',
      'neck_shoulders' => 'assets/images/neck_shoulders.svg',
      'wrists_hands' => 'assets/images/wrists_hands.svg',
      'breathing' => 'assets/images/breathing.svg',
      'attention_posture' => 'assets/images/control_room.svg',
      _ => null,
    };
  }
}
