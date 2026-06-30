import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('English reminder visual assets exist', () {
    final rawJson = File('content/en/reminders.json').readAsStringSync();
    final catalog = jsonDecode(rawJson) as Map<String, dynamic>;
    final reminders =
        (catalog['reminders'] as List<dynamic>).cast<Map<String, dynamic>>();

    for (final reminder in reminders) {
      final visualAsset = reminder['visual_asset'] as String?;
      expect(visualAsset, isNotNull, reason: reminder['id'] as String?);
      expect(File(visualAsset!).existsSync(), isTrue, reason: visualAsset);
    }
  });
}
