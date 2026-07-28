import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'reminder.dart';

class ReminderArt extends StatelessWidget {
  const ReminderArt({
    super.key,
    required this.reminder,
    this.height = 180,
  });

  final Reminder reminder;
  final double height;

  @override
  Widget build(BuildContext context) {
    final asset = reminder.visualAsset ?? assetForCategory(reminder.category);
    final isSvg = asset?.toLowerCase().endsWith('.svg') ?? false;

    return Semantics(
      label: reminder.visualDescription ?? reminder.title,
      image: true,
      child: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.all(isSvg ? 12 : 0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EF),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: asset == null
            ? Icon(
                Icons.self_improvement,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              )
            : _assetImage(asset, isSvg),
      ),
    );
  }

  Widget _assetImage(String asset, bool isSvg) {
    if (isSvg) {
      return SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
      );
    }

    return Image.asset(
      asset,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
    );
  }

  String? assetForCategory(String category) {
    return switch (category) {
      'eyes' => 'assets/images/realistic/eye_break_v2.webp',
      'posture' => 'assets/images/realistic/posture_reset_v2.webp',
      'movement' => 'assets/images/realistic/movement_walk_v2.webp',
      'neck_shoulders' => 'assets/images/realistic/neck_shoulders_v2.webp',
      'wrists_hands' => 'assets/images/realistic/wrists_hands_v2.webp',
      'breathing' => 'assets/images/realistic/breathing_v2.webp',
      'attention_posture' => 'assets/images/realistic/control_room_v2.webp',
      'driver_mobility' => 'assets/images/realistic/parked_mobility_v2.webp',
      _ => null,
    };
  }
}
