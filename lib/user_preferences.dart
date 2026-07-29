import 'guide_character.dart';
import 'reminder.dart';

class UserPreferences {
  const UserPreferences({
    required this.language,
    required this.jobProfile,
    required this.interval,
    required this.guideCharacter,
  });

  final ReminderLanguage language;
  final String jobProfile;
  final Duration interval;
  final GuideCharacter guideCharacter;

  static UserPreferences initial() {
    return const UserPreferences(
      language: ReminderLanguage.fa,
      jobProfile: 'office_computer',
      interval: Duration(seconds: 30),
      guideCharacter: GuideCharacter.female,
    );
  }

  UserPreferences copyWith({
    ReminderLanguage? language,
    String? jobProfile,
    Duration? interval,
    GuideCharacter? guideCharacter,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      jobProfile: jobProfile ?? this.jobProfile,
      interval: interval ?? this.interval,
      guideCharacter: guideCharacter ?? this.guideCharacter,
    );
  }
}
