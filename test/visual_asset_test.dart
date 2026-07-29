import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const animatedReminderIds = <String>{
    'shoulder-shrug-release',
    'seated-side-reach',
    'seated-chest-opener',
    'seated-ankle-flex',
    'sit-to-stand',
    'supported-calf-raise',
  };

  test('localized reminder visual assets exist and stay aligned', () {
    final english = _readReminders('content/en/reminders.json');
    final persian = _readReminders('content/fa/reminders.json');

    expect(persian.keys, english.keys);

    for (final id in english.keys) {
      final englishReminder = english[id]!;
      final persianReminder = persian[id]!;
      final visualAsset = englishReminder['visual_asset'] as String?;

      expect(visualAsset, isNotNull, reason: id);
      expect(File(visualAsset!).existsSync(), isTrue, reason: visualAsset);
      expect(englishReminder['visual_type'], 'static_webp', reason: id);
      expect(persianReminder['visual_asset'], visualAsset, reason: id);
      expect(
        persianReminder['visual_type'],
        englishReminder['visual_type'],
        reason: id,
      );
      expect(
        englishReminder['visual_description'],
        isA<String>().having((value) => value.isNotEmpty, 'not empty', true),
        reason: id,
      );
      expect(
        persianReminder['visual_description'],
        isA<String>().having((value) => value.isNotEmpty, 'not empty', true),
        reason: id,
      );

      final animationKeys = <String>[
        'animation_asset',
        'animation_asset_male',
        'animation_still_asset',
        'animation_still_asset_male',
      ];

      if (animatedReminderIds.contains(id)) {
        for (final key in animationKeys) {
          final animationAsset = englishReminder[key] as String?;
          expect(animationAsset, isNotNull, reason: '$id: $key');
          expect(
            File(animationAsset!).existsSync(),
            isTrue,
            reason: animationAsset,
          );
          expect(
            persianReminder[key],
            animationAsset,
            reason: '$id: $key',
          );
        }
      } else {
        for (final key in animationKeys) {
          expect(englishReminder[key], isNull, reason: '$id: $key');
          expect(persianReminder[key], isNull, reason: '$id: $key');
        }
      }
    }
  });
}

Map<String, Map<String, dynamic>> _readReminders(String path) {
  final rawJson = File(path).readAsStringSync();
  final catalog = jsonDecode(rawJson) as Map<String, dynamic>;
  final reminders =
      (catalog['reminders'] as List<dynamic>).cast<Map<String, dynamic>>();

  return {
    for (final reminder in reminders) reminder['id'] as String: reminder,
  };
}
