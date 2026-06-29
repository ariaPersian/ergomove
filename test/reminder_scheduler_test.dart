import 'package:flutter_test/flutter_test.dart';

import 'package:ergomove/reminder.dart';
import 'package:ergomove/reminder_scheduler.dart';

void main() {
  const scheduler = ReminderScheduler();

  const reminders = [
    Reminder(
      id: 'general-one',
      category: 'movement',
      jobProfiles: ['general'],
      intervalMinutes: 20,
      durationSeconds: 30,
      title: 'General reminder',
      body: 'General body',
      safetyNote: 'General note',
    ),
    Reminder(
      id: 'office-one',
      category: 'posture',
      jobProfiles: ['office_computer'],
      intervalMinutes: 20,
      durationSeconds: 30,
      title: 'Office reminder',
      body: 'Office body',
      safetyNote: 'Office note',
    ),
    Reminder(
      id: 'driver-one',
      category: 'movement',
      jobProfiles: ['driver'],
      intervalMinutes: 60,
      durationSeconds: 60,
      title: 'Driver reminder',
      body: 'Driver body',
      safetyNote: 'Driver note',
    ),
  ];

  test('matches profile-specific reminders and general reminders', () {
    final matching = scheduler.matchingReminders(
      reminders: reminders,
      jobProfile: 'office_computer',
    );

    expect(matching.map((reminder) => reminder.id), ['general-one', 'office-one']);
  });

  test('cycles through matching reminders by index', () {
    final first = scheduler.nextReminder(
      reminders: reminders,
      jobProfile: 'office_computer',
      nextIndex: 0,
    );
    final second = scheduler.nextReminder(
      reminders: reminders,
      jobProfile: 'office_computer',
      nextIndex: 1,
    );
    final third = scheduler.nextReminder(
      reminders: reminders,
      jobProfile: 'office_computer',
      nextIndex: 2,
    );

    expect(first?.id, 'general-one');
    expect(second?.id, 'office-one');
    expect(third?.id, 'general-one');
  });

  test('resets countdown to interval when due', () {
    final remaining = scheduler.tick(
      remaining: const Duration(seconds: 1),
      interval: const Duration(minutes: 20),
    );

    expect(remaining, const Duration(minutes: 20));
  });

  test('subtracts one second when not due', () {
    final remaining = scheduler.tick(
      remaining: const Duration(seconds: 10),
      interval: const Duration(minutes: 20),
    );

    expect(remaining, const Duration(seconds: 9));
  });
}
