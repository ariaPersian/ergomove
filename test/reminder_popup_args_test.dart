import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:ergomove/guide_character.dart';
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
    instructionSteps: [
      'صاف بنشینید.',
      'شانه‌ها را آرام حرکت دهید.',
    ],
    doseLabel: '۵ بار آرام',
    visualAsset: 'assets/images/neck_shoulders.svg',
    visualType: 'static_svg',
    visualDescription: 'حرکت آرام گردن و شانه',
    animationAsset: 'assets/animations/shoulder_shrug_v1.webp',
    animationAssetMale: 'assets/animations/shoulder_shrug_male_v1.webp',
    animationStillAsset: 'assets/animations/shoulder_shrug_v1_still.webp',
    animationStillAssetMale:
        'assets/animations/shoulder_shrug_male_v1_still.webp',
  );

  test('round-trips reminder payload, language, and guide character', () {
    const original = ReminderPopupArgs(
      reminder: reminder,
      language: ReminderLanguage.fa,
      guideCharacter: GuideCharacter.male,
    );

    final encoded = original.encode();
    final decoded = ReminderPopupArgs.decode(encoded);

    expect(ReminderPopupArgs.isPopup(encoded), isTrue);
    expect(decoded.language, ReminderLanguage.fa);
    expect(decoded.guideCharacter, GuideCharacter.male);
    expect(decoded.reminder.id, reminder.id);
    expect(decoded.reminder.jobProfiles, reminder.jobProfiles);
    expect(decoded.reminder.title, reminder.title);
    expect(decoded.reminder.body, reminder.body);
    expect(decoded.reminder.safetyNote, reminder.safetyNote);
    expect(decoded.reminder.instructionSteps, reminder.instructionSteps);
    expect(decoded.reminder.doseLabel, reminder.doseLabel);
    expect(decoded.reminder.visualAsset, reminder.visualAsset);
    expect(decoded.reminder.visualType, reminder.visualType);
    expect(
      decoded.reminder.visualDescription,
      reminder.visualDescription,
    );
    expect(decoded.reminder.animationAsset, reminder.animationAsset);
    expect(decoded.reminder.animationAssetMale, reminder.animationAssetMale);
    expect(
      decoded.reminder.animationStillAsset,
      reminder.animationStillAsset,
    );
    expect(
      decoded.reminder.animationStillAssetMale,
      reminder.animationStillAssetMale,
    );
  });

  test('defaults legacy payloads without language or guide selection', () {
    const original = ReminderPopupArgs(
      reminder: reminder,
      language: ReminderLanguage.fa,
      guideCharacter: GuideCharacter.male,
    );
    final legacyPayload =
        jsonDecode(original.encode()) as Map<String, dynamic>;
    legacyPayload.remove('language');
    legacyPayload.remove('guide_character');

    final decoded = ReminderPopupArgs.decode(jsonEncode(legacyPayload));

    expect(decoded.language, ReminderLanguage.en);
    expect(decoded.guideCharacter, GuideCharacter.female);
  });

  test('rejects empty, malformed, and unrelated payloads', () {
    expect(ReminderPopupArgs.isPopup(''), isFalse);
    expect(ReminderPopupArgs.isPopup('{not-json'), isFalse);
    expect(ReminderPopupArgs.isPopup('{"type":"other"}'), isFalse);
  });
}
