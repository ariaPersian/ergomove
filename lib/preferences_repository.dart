import 'package:shared_preferences/shared_preferences.dart';

import 'reminder.dart';
import 'user_preferences.dart';

class PreferencesRepository {
  const PreferencesRepository();

  static const _languageKey = 'language';
  static const _jobProfileKey = 'jobProfile';
  static const _intervalSecondsKey = 'intervalSeconds';

  Future<UserPreferences> load() async {
    final defaults = UserPreferences.initial();
    final prefs = await SharedPreferences.getInstance();

    return UserPreferences(
      language:
          _readLanguage(prefs.getString(_languageKey)) ?? defaults.language,
      jobProfile: prefs.getString(_jobProfileKey) ?? defaults.jobProfile,
      interval:
          _readInterval(prefs.getInt(_intervalSecondsKey)) ?? defaults.interval,
    );
  }

  Future<void> save(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, preferences.language.name);
    await prefs.setString(_jobProfileKey, preferences.jobProfile);
    await prefs.setInt(_intervalSecondsKey, preferences.interval.inSeconds);
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
}
