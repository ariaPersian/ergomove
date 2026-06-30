import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

class DesktopShellController with WindowListener, tray.TrayListener {
  DesktopShellController._();

  static final DesktopShellController instance = DesktopShellController._();

  bool _initialized = false;
  bool _exiting = false;

  Future<void> initialize() async {
    if (_initialized || !_isDesktop) return;

    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);
    tray.trayManager.addListener(this);

    await _configureTray();

    const windowOptions = WindowOptions(
      size: Size(1100, 820),
      center: true,
      skipTaskbar: false,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    _initialized = true;
  }

  bool get _isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  Future<void> _configureTray() async {
    if (Platform.isWindows) {
      await tray.trayManager.setIcon('windows/runner/resources/app_icon.ico');
    }

    await tray.trayManager.setToolTip('ErgoMove');
    await tray.trayManager.setContextMenu(
      tray.Menu(
        items: [
          tray.MenuItem(
            key: 'show_window',
            label: 'Show ErgoMove',
          ),
          tray.MenuItem.separator(),
          tray.MenuItem(
            key: 'exit_app',
            label: 'Exit',
          ),
        ],
      ),
    );
  }

  Future<void> hideToTray() async {
    if (!_isDesktop || _exiting) return;
    await windowManager.setSkipTaskbar(true);
    await windowManager.hide();
  }

  Future<void> showFromTray() async {
    if (!_isDesktop || _exiting) return;
    await windowManager.setSkipTaskbar(false);
    await windowManager.show();

    if (await windowManager.isMinimized()) {
      await windowManager.restore();
    }

    await windowManager.focus();
  }

  Future<void> exitApplication() async {
    if (!_isDesktop) return;

    _exiting = true;
    await windowManager.setPreventClose(false);
    await tray.trayManager.destroy();
    exit(0);
  }

  @override
  void onWindowClose() {
    unawaited(hideToTray());
  }

  @override
  void onWindowMinimize() {
    unawaited(hideToTray());
  }

  @override
  void onTrayIconMouseDown() {
    unawaited(showFromTray());
  }

  @override
  void onTrayIconRightMouseDown() {
    unawaited(tray.trayManager.popUpContextMenu());
  }

  @override
  void onTrayMenuItemClick(tray.MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        unawaited(showFromTray());
      case 'exit_app':
        unawaited(exitApplication());
    }
  }
}
