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

The current implementation has passed analyzer and tests locally on Windows.

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

Windows native notifications are not the target UX for ErgoMove reminders. The preferred UX is an ErgoMove-owned popup window that appears like a calm desktop reminder.

Required behavior:

1. The reminder should appear in a small popup near the Windows clock / system tray by default.
2. The popup position should become user-configurable later, with at least these options:
   - bottom-right
   - bottom-left
   - top-right
   - top-left
3. The popup should show:
   - movement image or animation
   - reminder title
   - reminder body
   - safety note
   - dismiss control
4. The popup should auto-dismiss after a short duration unless the user closes it earlier.
5. The popup must not block the main timer.
6. If the main window is hidden to tray, the popup should still be able to appear on the desktop.

Current implementation status:

- The current MVP shows an ErgoMove popup overlay inside the Flutter app window.
- The next implementation step is to move this popup into a dedicated desktop popup window positioned near the system tray.

Candidate implementation direction:

- Use a secondary desktop window for reminders.
- Keep the main app in tray mode.
- Position the popup window at the selected screen corner.
- Use the same `ReminderArt` and reminder content model as the main card.

`desktop_multi_window` is the candidate package for creating a separate desktop popup window because it supports Windows, Linux, and macOS and is intended for multiple desktop windows.

## Visual motion behavior

The current SVG images are placeholders. Production reminder visuals should be more natural and, where useful, animated.

Preferred visual asset order:

1. Lottie JSON for short looping movement guidance.
2. Animated WebP or GIF if Lottie is not available.
3. Static SVG or PNG as fallback.

Visual requirements:

- Show one movement at a time.
- Prefer natural human movement diagrams over abstract icons.
- Keep movements slow, low-risk, and non-medical.
- Avoid treatment, diagnosis, or pain-relief claims.
- Keep the asset linked to the reminder by `visual_asset` in the JSON catalog.

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
11. Reminder popup appears and can be dismissed.
12. In the future desktop-popup implementation, popup appears near the Windows clock by default.
