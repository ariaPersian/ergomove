import 'dart:convert';

import 'reminder.dart';

class ReminderPopupArgs {
  const ReminderPopupArgs({
    required this.reminder,
    required this.language,
  });

  final Reminder reminder;
  final ReminderLanguage language;

  factory ReminderPopupArgs.decode(String value) {
    final data = jsonDecode(value) as Map<String, dynamic>;
    return ReminderPopupArgs(
      reminder: Reminder.fromJson(
        data['reminder'] as Map<String, dynamic>,
      ),
      language: _decodeLanguage(data['language']),
    );
  }

  String encode() {
    return jsonEncode(<String, dynamic>{
      'type': 'reminderPopup',
      'language': language.name,
      'reminder': toMap(reminder),
    });
  }

  static bool isPopup(String value) {
    if (value.isEmpty) return false;
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      return data['type'] == 'reminderPopup';
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic> toMap(Reminder reminder) => <String, dynamic>{
        'id': reminder.id,
        'category': reminder.category,
        'job_profiles': reminder.jobProfiles,
        'interval_minutes': reminder.intervalMinutes,
        'duration_seconds': reminder.durationSeconds,
        'title': reminder.title,
        'body': reminder.body,
        'safety_note': reminder.safetyNote,
        'instruction_steps': reminder.instructionSteps,
        'dose_label': reminder.doseLabel,
        'visual_asset': reminder.visualAsset,
        'visual_type': reminder.visualType,
        'visual_description': reminder.visualDescription,
      };

  static ReminderLanguage _decodeLanguage(Object? value) {
    for (final language in ReminderLanguage.values) {
      if (language.name == value) return language;
    }
    return ReminderLanguage.en;
  }
}
