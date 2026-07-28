import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
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
