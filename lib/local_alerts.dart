import 'package:local_notifier/local_notifier.dart';

import 'reminder.dart';

class LocalAlerts {
  const LocalAlerts();

  Future<void> initialize() {
    return localNotifier.setup(
      appName: 'ErgoMove',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  void showReminder(Reminder reminder) {
    final alert = LocalNotification(
      title: reminder.title,
      body: reminder.body,
    );
    alert.show();
  }
}
