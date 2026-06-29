import 'reminder.dart';

class ReminderScheduler {
  const ReminderScheduler();

  List<Reminder> matchingReminders({
    required List<Reminder> reminders,
    required String jobProfile,
  }) {
    return reminders
        .where((reminder) => reminder.matchesJobProfile(jobProfile))
        .toList(growable: false);
  }

  Reminder? nextReminder({
    required List<Reminder> reminders,
    required String jobProfile,
    required int nextIndex,
  }) {
    final matching = matchingReminders(
      reminders: reminders,
      jobProfile: jobProfile,
    );

    if (matching.isEmpty) return null;
    return matching[nextIndex % matching.length];
  }

  int nextIndexAfterSelection({
    required List<Reminder> reminders,
    required String jobProfile,
    required int currentIndex,
  }) {
    final matching = matchingReminders(
      reminders: reminders,
      jobProfile: jobProfile,
    );

    if (matching.isEmpty) return currentIndex;
    return currentIndex + 1;
  }

  Duration tick({
    required Duration remaining,
    required Duration interval,
  }) {
    if (remaining.inSeconds <= 1) return interval;
    return remaining - const Duration(seconds: 1);
  }

  bool isDue(Duration remaining) => remaining.inSeconds <= 1;
}
