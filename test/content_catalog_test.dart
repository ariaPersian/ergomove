import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('English and Persian reminder catalogs have matching ids', () {
    final en = _readCatalog('content/en/reminders.json');
    final fa = _readCatalog('content/fa/reminders.json');

    final enIds = _ids(en);
    final faIds = _ids(fa);

    expect(enIds, faIds);
  });

  test('each reminder has required safe content fields', () {
    for (final path in [
      'content/en/reminders.json',
      'content/fa/reminders.json'
    ]) {
      final catalog = _readCatalog(path);
      final reminders = catalog['reminders'] as List<dynamic>;

      expect(reminders, isNotEmpty, reason: path);

      for (final item in reminders.cast<Map<String, dynamic>>()) {
        expect(
            item['id'],
            isA<String>()
                .having((value) => value.isNotEmpty, 'not empty', true));
        expect(
            item['title'],
            isA<String>()
                .having((value) => value.isNotEmpty, 'not empty', true));
        expect(
            item['body'],
            isA<String>()
                .having((value) => value.isNotEmpty, 'not empty', true));
        expect(
            item['safety_note'],
            isA<String>()
                .having((value) => value.isNotEmpty, 'not empty', true));
        expect(
            item['job_profiles'],
            isA<List<dynamic>>()
                .having((value) => value.isNotEmpty, 'not empty', true));
        expect(item['interval_minutes'],
            isA<int>().having((value) => value > 0, 'positive', true));
        expect(item['duration_seconds'],
            isA<int>().having((value) => value > 0, 'positive', true));
      }
    }
  });
}

Map<String, dynamic> _readCatalog(String path) {
  final rawJson = File(path).readAsStringSync();
  return jsonDecode(rawJson) as Map<String, dynamic>;
}

Set<String> _ids(Map<String, dynamic> catalog) {
  return (catalog['reminders'] as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .map((item) => item['id'] as String)
      .toSet();
}
