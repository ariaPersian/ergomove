import 'dart:async';

import 'package:flutter/material.dart';

import 'local_alerts.dart';
import 'preferences_repository.dart';
import 'reminder.dart';
import 'reminder_art.dart';
import 'reminder_repository.dart';
import 'user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await const LocalAlerts().initialize();
  } catch (_) {
    // The app still works with in-app reminders when system alerts are unavailable.
  }

  runApp(const ErgoMoveApp());
}

class ErgoMoveApp extends StatelessWidget {
  const ErgoMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ErgoMove',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({
    super.key,
    this.repository = const ReminderRepository(),
    this.preferencesRepository = const PreferencesRepository(),
    this.localAlerts = const LocalAlerts(),
  });

  final ReminderRepository repository;
  final PreferencesRepository preferencesRepository;
  final LocalAlerts localAlerts;

  @override
  State<ReminderHomePage> createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  static const Map<String, String> _jobProfileLabelsEn = {
    'office_computer': 'Office / computer',
    'call_center': 'Call center',
    'control_room': 'Control room',
    'driver': 'Driver',
  };

  static const Map<String, String> _jobProfileLabelsFa = {
    'office_computer': 'اداری / کامپیوتر',
    'call_center': 'مرکز تماس',
    'control_room': 'اتاق کنترل',
    'driver': 'راننده',
  };

  static const List<Duration> _intervalOptions = [
    Duration(seconds: 30),
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 20),
  ];

  ReminderLanguage _language = UserPreferences.initial().language;
  String _jobProfile = UserPreferences.initial().jobProfile;
  Duration _interval = UserPreferences.initial().interval;
  Duration _remaining = UserPreferences.initial().interval;
  Timer? _timer;
  bool _running = false;
  bool _loading = true;
  List<Reminder> _reminders = const [];
  int _nextIndex = 0;
  Reminder? _activeReminder;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialState() async {
    final preferences = await widget.preferencesRepository.load();
    final language = preferences.language;
    final reminders = await widget.repository.load(language);

    if (!mounted) return;

    setState(() {
      _language = language;
      _jobProfile = _safeJobProfile(preferences.jobProfile);
      _interval = _safeInterval(preferences.interval);
      _remaining = _interval;
      _reminders = reminders;
      _nextIndex = 0;
      _activeReminder = _nextReminder();
      _loading = false;
    });
  }

  Future<void> _loadRemindersForLanguage(ReminderLanguage language) async {
    final reminders = await widget.repository.load(language);
    if (!mounted || language != _language) return;

    setState(() {
      _reminders = reminders;
      _nextIndex = 0;
      _activeReminder = _nextReminder();
      _loading = false;
      _remaining = _interval;
    });
  }

  List<Reminder> get _matchingReminders => _reminders
      .where((reminder) => reminder.matchesJobProfile(_jobProfile))
      .toList(growable: false);

  Reminder? _nextReminder() {
    final matching = _matchingReminders;
    if (matching.isEmpty) return null;

    final reminder = matching[_nextIndex % matching.length];
    _nextIndex += 1;
    return reminder;
  }

  String _safeJobProfile(String jobProfile) {
    if (_jobProfileLabelsEn.containsKey(jobProfile)) return jobProfile;
    return UserPreferences.initial().jobProfile;
  }

  Duration _safeInterval(Duration interval) {
    if (_intervalOptions.contains(interval)) return interval;
    return UserPreferences.initial().interval;
  }

  void _savePreferences() {
    unawaited(
      widget.preferencesRepository.save(
        UserPreferences(
          language: _language,
          jobProfile: _jobProfile,
          interval: _interval,
        ),
      ),
    );
  }

  void _showLocalAlert(Reminder reminder) {
    try {
      widget.localAlerts.showReminder(reminder);
    } catch (_) {
      // The visual timer card remains the source of truth if a system alert fails.
    }
  }

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() => _running = true);
  }

  void _tick() {
    if (!mounted) return;

    Reminder? reminderToAlert;

    setState(() {
      if (_remaining.inSeconds <= 1) {
        reminderToAlert = _nextReminder();
        _activeReminder = reminderToAlert;
        _remaining = _interval;
      } else {
        _remaining -= const Duration(seconds: 1);
      }
    });

    final reminder = reminderToAlert;
    if (reminder != null) {
      _showLocalAlert(reminder);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remaining = _interval;
    });
  }

  void _showNextReminderNow() {
    Reminder? nextReminder;

    setState(() {
      nextReminder = _nextReminder();
      _activeReminder = nextReminder;
      _remaining = _interval;
    });

    final reminder = nextReminder;
    if (reminder != null) {
      _showLocalAlert(reminder);
    }
  }

  void _changeLanguage(ReminderLanguage? language) {
    if (language == null || _language == language) return;
    _timer?.cancel();

    setState(() {
      _language = language;
      _running = false;
      _loading = true;
    });

    _savePreferences();
    unawaited(_loadRemindersForLanguage(language));
  }

  void _changeJobProfile(String? profile) {
    if (profile == null || profile == _jobProfile) return;

    setState(() {
      _jobProfile = _safeJobProfile(profile);
      _nextIndex = 0;
      _activeReminder = _nextReminder();
      _remaining = _interval;
    });

    _savePreferences();
  }

  void _changeInterval(Duration? interval) {
    if (interval == null || interval == _interval) return;

    setState(() {
      _interval = _safeInterval(interval);
      _remaining = _interval;
    });

    _savePreferences();
  }

  String _copy(String en, String fa) =>
      _language == ReminderLanguage.fa ? fa : en;

  String _jobLabel(String value) {
    final labels = _language == ReminderLanguage.fa
        ? _jobProfileLabelsFa
        : _jobProfileLabelsEn;
    return labels[value] ?? value;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _intervalLabel(Duration duration) {
    if (duration.inSeconds == 30) {
      return _copy('30 seconds demo', '۳۰ ثانیه آزمایشی');
    }
    return _copy(
        '${duration.inMinutes} minutes', '${duration.inMinutes} دقیقه');
  }

  @override
  Widget build(BuildContext context) {
    final textDirection =
        _language.isRtl ? TextDirection.rtl : TextDirection.ltr;
    final reminder = _activeReminder;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ErgoMove'),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ReminderLanguage>(
                  value: _language,
                  onChanged: _changeLanguage,
                  items: ReminderLanguage.values
                      .map(
                        (language) => DropdownMenuItem(
                          value: language,
                          child: Text(language.label),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _loading
                  ? const CircularProgressIndicator()
                  : ListView(
                      children: [
                        Text(
                          _copy('Work profile', 'پروفایل کاری'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _jobProfile,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: _copy('Job type', 'نوع شغل'),
                          ),
                          onChanged: _changeJobProfile,
                          items: _jobProfileLabelsEn.keys
                              .map(
                                (profile) => DropdownMenuItem(
                                  value: profile,
                                  child: Text(_jobLabel(profile)),
                                ),
                              )
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Duration>(
                          initialValue: _interval,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                _copy('Reminder interval', 'فاصله یادآوری'),
                          ),
                          onChanged: _changeInterval,
                          items: _intervalOptions
                              .map(
                                (interval) => DropdownMenuItem(
                                  value: interval,
                                  child: Text(_intervalLabel(interval)),
                                ),
                              )
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _copy('Next reminder in', 'یادآور بعدی تا'),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatDuration(_remaining),
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _running
                                      ? _copy(
                                          'Timer is running', 'تایمر فعال است')
                                      : _copy(
                                          'Timer is paused', 'تایمر متوقف است'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card.filled(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: reminder == null
                                ? Text(_copy(
                                    'No reminder is available for this profile.',
                                    'برای این پروفایل کاری یادآوری موجود نیست.',
                                  ))
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReminderArt(reminder: reminder),
                                      const SizedBox(height: 16),
                                      Text(
                                        reminder.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        reminder.body,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        reminder.safetyNote,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: _toggleTimer,
                              icon: Icon(
                                  _running ? Icons.pause : Icons.play_arrow),
                              label: Text(_running
                                  ? _copy('Pause', 'توقف')
                                  : _copy('Start', 'شروع')),
                            ),
                            OutlinedButton.icon(
                              onPressed: _resetTimer,
                              icon: const Icon(Icons.restart_alt),
                              label: Text(_copy('Reset', 'بازنشانی')),
                            ),
                            OutlinedButton.icon(
                              onPressed: _showNextReminderNow,
                              icon: const Icon(Icons.skip_next),
                              label: Text(_copy('Show next', 'نمایش بعدی')),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
