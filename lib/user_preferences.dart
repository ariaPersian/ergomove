import 'reminder.dart';

class UserPreferences {
  const UserPreferences({
    required this.language,
    required this.jobProfile,
    required this.interval,
  });

  final ReminderLanguage language;
  final String jobProfile;
  final Duration interval;

  static UserPreferences initial() {
    return const UserPreferences(
      language: ReminderLanguage.fa,
      jobProfile: 'office_computer',
      interval: Duration(seconds: 30),
    );
  }

  UserPreferences copyWith({
    ReminderLanguage? language,
    String? jobProfile,
    Duration? interval,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      jobProfile: jobProfile ?? this.jobProfile,
      interval: interval ?? this.interval,
    );
  }
}
