# Desktop runtime behavior

This document defines the Windows-first desktop behavior for ErgoMove.

## Current validated state

The Windows debug build has been manually validated with:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

The previous implementation passed analyzer and tests locally on Windows. After each desktop-window change, rerun the validation checklist below.

## System tray behavior

ErgoMove should behave like a background ergonomic reminder app, not like a document editor that closes immediately when the user presses the window close button.

Required behavior:

1. When the user closes the main window, the app should hide to the system tray instead of terminating.
2. When the user minimizes the main window, the app should hide to the system tray.
3. The tray icon should remain visible while the timer is active or the app is running in the background.
4. Left-clicking the tray icon should restore and focus the main window.
5. Right-clicking the tray icon should open a context menu.
6. The context menu must include:
   - `Show ErgoMove`
   - `Exit`
7. The app should terminate only when the user explicitly chooses `Exit` from the tray menu.

Implementation files:

- `lib/desktop_shell_controller.dart`
- `windows/runner/resources/app_icon.ico`

Dependencies:

- `tray_manager`
- `window_manager`

## Reminder popup behavior

Windows native notifications are not the target UX for ErgoMove reminders. The preferred UX is an ErgoMove-owned desktop popup window that appears like a calm reminder near the Windows clock / system tray.

Required behavior:

1. The reminder should appear in a small independent desktop popup near the Windows clock / system tray by default.
2. The popup position should become user-configurable later, with at least these options:
   - bottom-right
   - bottom-left
   - top-right
   - top-left
3. The popup should show:
   - movement image or animation
   - reminder title
   - reminder body
   - dose / repetition label
   - numbered instruction steps
   - safety note
   - dismiss control
4. The popup should auto-dismiss after a short duration unless the user closes it earlier.
5. The popup must not block the main timer.
6. If the main window is hidden to tray, the popup should still be able to appear on the desktop.

Current implementation status:

- The current implementation creates a dedicated desktop popup window using `desktop_multi_window`.
- The popup window receives a serialized `Reminder` payload through `lib/reminder_popup_args.dart`.
- The popup payload carries the selected language and woman/man movement-guide
  preference so Persian content uses RTL controls and both windows render the
  same guide.
- The popup window uses `ReminderPopup`, `ReminderArt`, and
  `ReminderGuidance`, so it shows the same visual, dose, steps, and safety note
  as the main reminder card.
- The popup window is configured with `window_manager` as always-on-top, hidden from the taskbar, fixed size, and aligned to bottom-right.
- The popup auto-dismisses after the reminder duration, clamped to 20–60
  seconds, or when the user presses its close button.
- Animated WebP guides loop in the main card and popup. When the platform asks
  for reduced motion, both surfaces render the paired static start/peak image.
- The Windows runner registers generated plugins for every secondary Flutter engine created by `desktop_multi_window`.

Implementation files:

- `lib/main.dart`
- `lib/reminder_popup.dart`
- `lib/reminder_popup_args.dart`

Dependencies:

- `desktop_multi_window`
- `window_manager`

Native Windows requirement:

Each popup owns a separate Flutter engine. Keep the
`DesktopMultiWindowSetWindowCreatedCallback` registration in
`windows/runner/flutter_window.cpp`; without it, plugins such as
`window_manager` are unavailable inside popup windows.

## Visual motion behavior

The active catalog uses natural static WebP illustrations and a reviewed
Animated WebP pilot. Legacy SVG images remain available as fallbacks.

Preferred visual asset order:

1. Lottie JSON for short looping movement guidance.
2. Animated WebP if Lottie is not available.
3. Static WebP, SVG, or PNG as fallback.

Visual requirements:

- Show one movement at a time.
- Prefer natural human movement diagrams over abstract icons.
- Keep movements slow, low-risk, and non-medical.
- Avoid treatment, diagnosis, or pain-relief claims.
- Keep the asset linked to the reminder by `visual_asset` in the JSON catalog.
- Keep woman/man animation and reduced-motion asset fields aligned in the
  English and Persian catalogs.

## Manual validation checklist

Run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

Then validate:

1. Main window opens normally.
2. Timer starts and counts down.
3. `Show next` changes the reminder card.
4. Reminder art appears in the card.
5. Closing the main window hides the app to the tray.
6. Minimizing the main window hides the app to the tray.
7. Tray icon is visible.
8. Tray left-click restores the main window.
9. Tray right-click opens the menu.
10. `Exit` from tray terminates the app.
11. `Show next` opens a separate popup near the Windows clock / system tray.
12. When the timer reaches zero, a separate popup appears near the Windows clock / system tray.
13. The popup shows movement visual, title, body, dose, numbered steps, and
    safety note.
14. The popup auto-dismisses after the reminder duration, clamped to 20–60
    seconds.
15. The popup close button dismisses it immediately.
16. Persian popup content is RTL and its close tooltip is localized.
17. Changing the movement guide between woman and man persists after restart.
18. Animated reminders use the same selected guide in the card and popup.
19. Windows reduced-motion mode shows a static start/peak pair.
