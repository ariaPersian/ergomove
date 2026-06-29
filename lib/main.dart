import 'dart:async';

import 'package:flutter/material.dart';

import 'reminder.dart';
import 'reminder_repository.dart';

void main() => runApp(const ErgoMoveApp());

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
  });

  final ReminderRepository repository;

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

  ReminderLanguage _language = ReminderLanguage.fa;
  String _jobProfile = 'office_computer';
  Duration _interval = const Duration(seconds: 30);
  Duration _remaining = const Duration(seconds: 30);
  Timer? _timer;
  bool _running = false;
  bool _loading = true;
  List<Reminder> _reminders = const [];
  int _nextIndex = 0;
  Reminder? _activeReminder;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    setState(() => _loading = true);
    final reminders = await widget.repository.load(_language);
    if (!mounted) return;

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

    setState(() {
      if (_remaining.inSeconds <= 1) {
        _activeReminder = _nextReminder();
        _remaining = _interval;
      } else {
        _remaining -= const Duration(seconds: 1);
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remaining = _interval;
    });
  }

  void _showNextReminderNow() {
    setState(() {
      _activeReminder = _nextReminder();
      _remaining = _interval;
    });
  }

  void _changeLanguage(ReminderLanguage language) {
    if (_language == language) return;
    _timer?.cancel();
    setState(() {
      _language = language;
      _running = false;
    });
    _loadReminders();
  }

  void _changeJobProfile(String? profile) {
    if (profile == null || profile == _jobProfile) return;
    setState(() {
      _jobProfile = profile;
      _nextIndex = 0;
      _activeReminder = _nextReminder();
      _remaining = _interval;
    });
  }

  void _changeInterval(Duration? interval) {
    if (interval == null || interval == _interval) return;
    setState(() {
      _interval = interval;
      _remaining = interval;
    });
  }

  String _copy(String en, String fa) => _language == ReminderLanguage.fa ? fa : en;

  String _jobLabel(String value) {
    final labels = _language == ReminderLanguage.fa ? _jobProfileLabelsFa : _jobProfileLabelsEn;
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
    return _copy('${duration.inMinutes} minutes', '${duration.inMinutes} دقیقه');
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = _language.isRtl ? TextDirection.rtl : TextDirection.ltr;
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
                  onChanged: (value) {
                    if (value != null) _changeLanguage(value);
                  },
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
                          value: _jobProfile,
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
                          value: _interval,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: _copy('Reminder interval', 'فاصله یادآوری'),
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
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _running
                                      ? _copy('Timer is running', 'تایمر فعال است')
                                      : _copy('Timer is paused', 'تایمر متوقف است'),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminder.title,
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        reminder.body,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        reminder.safetyNote,
                                        style: Theme.of(context).textTheme.bodySmall,
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
                              icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                              label: Text(_running ? _copy('Pause', 'توقف') : _copy('Start', 'شروع')),
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
