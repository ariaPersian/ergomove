import 'reminder.dart';

enum GuideCharacter {
  female,
  male;

  String label(ReminderLanguage language) {
    return switch ((this, language)) {
      (GuideCharacter.female, ReminderLanguage.en) => 'Woman',
      (GuideCharacter.female, ReminderLanguage.fa) => 'زن',
      (GuideCharacter.male, ReminderLanguage.en) => 'Man',
      (GuideCharacter.male, ReminderLanguage.fa) => 'مرد',
    };
  }
}
