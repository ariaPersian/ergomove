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
    final isSvg = visualAsset?.toLowerCase().endsWith('.svg') ?? false;

    return Semantics(
      label: reminder.visualDescription ?? reminder.title,
      image: true,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EF),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: visualAsset == null || visualAsset.isEmpty
            ? Icon(
                Icons.self_improvement,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              )
            : _assetImage(visualAsset, isSvg),
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
}
