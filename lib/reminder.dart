enum ReminderLanguage {
  en,
  fa;

  String get assetPath => switch (this) {
        ReminderLanguage.en => 'content/en/reminders.json',
        ReminderLanguage.fa => 'content/fa/reminders.json',
      };

  String get label => switch (this) {
        ReminderLanguage.en => 'English',
        ReminderLanguage.fa => 'فارسی',
      };

  bool get isRtl => this == ReminderLanguage.fa;
}

class Reminder {
  const Reminder({
    required this.id,
    required this.category,
    required this.jobProfiles,
    required this.intervalMinutes,
    required this.durationSeconds,
    required this.title,
    required this.body,
    required this.safetyNote,
  });

  final String id;
  final String category;
  final List<String> jobProfiles;
  final int intervalMinutes;
  final int durationSeconds;
  final String title;
  final String body;
  final String safetyNote;

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      jobProfiles: (json['job_profiles'] as List<dynamic>? ?? const <dynamic>['general'])
          .map((value) => value.toString())
          .toList(growable: false),
      intervalMinutes: json['interval_minutes'] as int? ?? 20,
      durationSeconds: json['duration_seconds'] as int? ?? 30,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      safetyNote: json['safety_note'] as String? ?? '',
    );
  }

  bool matchesJobProfile(String jobProfile) {
    return jobProfiles.contains(jobProfile) || jobProfiles.contains('general');
  }
}
