import 'package:shared_preferences/shared_preferences.dart';

import 'guide_character.dart';
import 'reminder.dart';
import 'user_preferences.dart';

class PreferencesRepository {
  const PreferencesRepository();

  static const _languageKey = 'language';
  static const _jobProfileKey = 'jobProfile';
  static const _intervalSecondsKey = 'intervalSeconds';
  static const _guideCharacterKey = 'guideCharacter';

  Future<UserPreferences> load() async {
    final defaults = UserPreferences.initial();
    final prefs = await SharedPreferences.getInstance();

    return UserPreferences(
      language:
          _readLanguage(prefs.getString(_languageKey)) ?? defaults.language,
      jobProfile: prefs.getString(_jobProfileKey) ?? defaults.jobProfile,
      interval:
          _readInterval(prefs.getInt(_intervalSecondsKey)) ?? defaults.interval,
      guideCharacter:
          _readGuideCharacter(prefs.getString(_guideCharacterKey)) ??
              defaults.guideCharacter,
    );
  }

  Future<void> save(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, preferences.language.name);
    await prefs.setString(_jobProfileKey, preferences.jobProfile);
    await prefs.setInt(_intervalSecondsKey, preferences.interval.inSeconds);
    await prefs.setString(
      _guideCharacterKey,
      preferences.guideCharacter.name,
    );
  }

  ReminderLanguage? _readLanguage(String? rawValue) {
    if (rawValue == null) return null;

    for (final language in ReminderLanguage.values) {
      if (language.name == rawValue) return language;
    }

    return null;
  }

  Duration? _readInterval(int? seconds) {
    if (seconds == null || seconds <= 0) return null;
    return Duration(seconds: seconds);
  }

  GuideCharacter? _readGuideCharacter(String? rawValue) {
    if (rawValue == null) return null;

    for (final character in GuideCharacter.values) {
      if (character.name == rawValue) return character;
    }

    return null;
  }
}
