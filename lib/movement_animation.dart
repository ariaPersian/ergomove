import 'package:flutter/material.dart';

class MovementAnimation extends StatelessWidget {
  const MovementAnimation({
    super.key,
    required this.animatedAsset,
    required this.stillAsset,
  });

  final String animatedAsset;
  final String stillAsset;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final asset = reduceMotion ? stillAsset : animatedAsset;

    return Image.asset(
      asset,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          stillAsset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          excludeFromSemantics: true,
        );
      },
    );
  }
}
