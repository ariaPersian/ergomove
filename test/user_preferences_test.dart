import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ergomove/guide_character.dart';
import 'package:ergomove/preferences_repository.dart';
import 'package:ergomove/reminder.dart';
import 'package:ergomove/user_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('loads initial values when storage is empty', () async {
    final repository = PreferencesRepository();

    final preferences = await repository.load();

    expect(preferences.language, UserPreferences.initial().language);
    expect(preferences.jobProfile, UserPreferences.initial().jobProfile);
    expect(preferences.interval, UserPreferences.initial().interval);
    expect(
      preferences.guideCharacter,
      UserPreferences.initial().guideCharacter,
    );
  });

  test('saves and reloads values', () async {
    final repository = PreferencesRepository();
    const expected = UserPreferences(
      language: ReminderLanguage.en,
      jobProfile: 'control_room',
      interval: Duration(minutes: 10),
      guideCharacter: GuideCharacter.male,
    );

    await repository.save(expected);
    final actual = await repository.load();

    expect(actual.language, expected.language);
    expect(actual.jobProfile, expected.jobProfile);
    expect(actual.interval, expected.interval);
    expect(actual.guideCharacter, expected.guideCharacter);
  });
}
