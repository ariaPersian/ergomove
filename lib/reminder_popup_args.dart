import 'dart:convert';

import 'reminder.dart';

class ReminderPopupArgs {
  const ReminderPopupArgs(this.reminder);

  final Reminder reminder;

  factory ReminderPopupArgs.decode(String value) {
    final data = jsonDecode(value) as Map<String, dynamic>;
    return ReminderPopupArgs(Reminder.fromJson(data['reminder'] as Map<String, dynamic>));
  }

  String encode() {
    return jsonEncode(<String, dynamic>{'type': 'reminderPopup', 'reminder': toMap(reminder)});
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
        'visual_asset': reminder.visualAsset,
        'visual_type': reminder.visualType,
        'visual_description': reminder.visualDescription,
      };
}
