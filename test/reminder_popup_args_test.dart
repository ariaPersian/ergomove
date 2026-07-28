import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:ergomove/reminder.dart';
import 'package:ergomove/reminder_popup_args.dart';

void main() {
  const reminder = Reminder(
    id: 'neck-shoulder-release',
    category: 'neck_shoulders',
    jobProfiles: ['general', 'office_computer'],
    intervalMinutes: 45,
    durationSeconds: 30,
    title: 'رهاسازی گردن و شانه',
    body: 'حرکت را آرام انجام دهید.',
    safetyNote: 'در صورت درد، حرکت را متوقف کنید.',
    visualAsset: 'assets/images/neck_shoulders.svg',
    visualType: 'static_svg',
    visualDescription: 'حرکت آرام گردن و شانه',
  );

  test('round-trips reminder payload and language', () {
    const original = ReminderPopupArgs(
      reminder: reminder,
      language: ReminderLanguage.fa,
    );

    final encoded = original.encode();
    final decoded = ReminderPopupArgs.decode(encoded);

    expect(ReminderPopupArgs.isPopup(encoded), isTrue);
    expect(decoded.language, ReminderLanguage.fa);
    expect(decoded.reminder.id, reminder.id);
    expect(decoded.reminder.jobProfiles, reminder.jobProfiles);
    expect(decoded.reminder.title, reminder.title);
    expect(decoded.reminder.body, reminder.body);
    expect(decoded.reminder.safetyNote, reminder.safetyNote);
    expect(decoded.reminder.visualAsset, reminder.visualAsset);
    expect(decoded.reminder.visualType, reminder.visualType);
    expect(
      decoded.reminder.visualDescription,
      reminder.visualDescription,
    );
  });

  test('defaults legacy payloads without language to English', () {
    const original = ReminderPopupArgs(
      reminder: reminder,
      language: ReminderLanguage.fa,
    );
    final legacyPayload =
        jsonDecode(original.encode()) as Map<String, dynamic>;
    legacyPayload.remove('language');

    final decoded = ReminderPopupArgs.decode(jsonEncode(legacyPayload));

    expect(decoded.language, ReminderLanguage.en);
  });

  test('rejects empty, malformed, and unrelated payloads', () {
    expect(ReminderPopupArgs.isPopup(''), isFalse);
    expect(ReminderPopupArgs.isPopup('{not-json'), isFalse);
    expect(ReminderPopupArgs.isPopup('{"type":"other"}'), isFalse);
  });
}
