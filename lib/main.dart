import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const ErgoMoveApp());

class Reminder {
  const Reminder({
    required this.category,
    required this.enTitle,
    required this.enBody,
    required this.faTitle,
    required this.faBody,
  });

  final String category;
  final String enTitle;
  final String enBody;
  final String faTitle;
  final String faBody;
}

const List<Reminder> seedReminders = [
  Reminder(
    category: 'eyes',
    enTitle: 'Eye break',
    enBody: 'Look away from the screen and focus on a distant object for 20 seconds.',
    faTitle: 'استراحت چشم',
    faBody: '۲۰ ثانیه از صفحه‌نمایش دور شوید و به یک نقطه دور نگاه کنید.',
  ),
  Reminder(
    category: 'posture',
    enTitle: 'Posture reset',
    enBody: 'Relax your shoulders, keep your head level, and place both feet fully supported.',
    faTitle: 'اصلاح وضعیت نشستن',
    faBody: 'شانه‌ها را رها کنید، سر را صاف نگه دارید و کف هر دو پا را کامل روی زمین یا زیرپایی قرار دهید.',
  ),
  Reminder(
    category: 'movement',
    enTitle: 'Move for a minute',
    enBody: 'Stand up, walk gently, and loosen your hips and back before returning to work.',
    faTitle: 'یک دقیقه حرکت',
    faBody: 'بلند شوید، آرام راه بروید و لگن و کمر را کمی آزاد کنید، بعد به کار برگردید.',
  ),
];

class ErgoMoveApp extends StatelessWidget {
  const ErgoMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ErgoMove',
      theme: ThemeData(useMaterial3: true),
      home: const ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  State<ReminderHomePage> createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  bool persian = true;
  int index = 0;
  int secondsUntilNext = 20 * 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (secondsUntilNext > 0) {
          secondsUntilNext--;
        } else {
          index = (index + 1) % seedReminders.length;
          secondsUntilNext = 20 * 60;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reminder = seedReminders[index];
    final minutes = secondsUntilNext ~/ 60;
    final seconds = secondsUntilNext % 60;
    final direction = persian ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ErgoMove'),
          actions: [
            TextButton(
              onPressed: () => setState(() => persian = !persian),
              child: Text(persian ? 'English' : 'فارسی'),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    persian ? 'یادآور بعدی' : 'Next reminder',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            persian ? reminder.faTitle : reminder.enTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            persian ? reminder.faBody : reminder.enBody,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => setState(() {
                      index = (index + 1) % seedReminders.length;
                      secondsUntilNext = 20 * 60;
                    }),
                    child: Text(persian ? 'نمایش یادآور بعدی' : 'Show next reminder'),
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
