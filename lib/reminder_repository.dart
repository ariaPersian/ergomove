import 'dart:convert';

import 'package:flutter/services.dart';

import 'reminder.dart';

class ReminderRepository {
  const ReminderRepository({AssetBundle? bundle}) : _bundle = bundle;

  final AssetBundle? _bundle;

  Future<List<Reminder>> load(ReminderLanguage language) async {
    final bundle = _bundle ?? rootBundle;
    final rawJson = await bundle.loadString(language.assetPath);
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final items = decoded['reminders'] as List<dynamic>? ?? const <dynamic>[];

    return items
        .map((item) => Reminder.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
