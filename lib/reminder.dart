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
    this.instructionSteps = const <String>[],
    this.doseLabel,
    this.visualAsset,
    this.visualType = 'static_svg',
    this.visualDescription,
    this.animationAsset,
    this.animationAssetMale,
    this.animationStillAsset,
    this.animationStillAssetMale,
  });

  final String id;
  final String category;
  final List<String> jobProfiles;
  final int intervalMinutes;
  final int durationSeconds;
  final String title;
  final String body;
  final String safetyNote;
  final List<String> instructionSteps;
  final String? doseLabel;
  final String? visualAsset;
  final String visualType;
  final String? visualDescription;
  final String? animationAsset;
  final String? animationAssetMale;
  final String? animationStillAsset;
  final String? animationStillAssetMale;

  bool get hasMovementAnimation =>
      animationAsset != null && animationStillAsset != null;

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      jobProfiles:
          (json['job_profiles'] as List<dynamic>? ?? const <dynamic>['general'])
              .map((value) => value.toString())
              .toList(growable: false),
      intervalMinutes: json['interval_minutes'] as int? ?? 20,
      durationSeconds: json['duration_seconds'] as int? ?? 30,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      safetyNote: json['safety_note'] as String? ?? '',
      instructionSteps:
          (json['instruction_steps'] as List<dynamic>? ?? const <dynamic>[])
              .map((value) => value.toString())
              .toList(growable: false),
      doseLabel: json['dose_label'] as String?,
      visualAsset: json['visual_asset'] as String?,
      visualType: json['visual_type'] as String? ?? 'static_svg',
      visualDescription: json['visual_description'] as String?,
      animationAsset: json['animation_asset'] as String?,
      animationAssetMale: json['animation_asset_male'] as String?,
      animationStillAsset: json['animation_still_asset'] as String?,
      animationStillAssetMale: json['animation_still_asset_male'] as String?,
    );
  }

  bool matchesJobProfile(String jobProfile) {
    return jobProfiles.contains(jobProfile) || jobProfiles.contains('general');
  }
}
