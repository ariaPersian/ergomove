# ErgoMove — Bilingual Ergonomic Break Reminder

ErgoMove is a Windows-first, cross-platform ergonomic reminder app concept. The product reminds office workers, computer users, and other low-movement roles to take micro-breaks, rest their eyes, stretch safely, hydrate, and correct workstation posture.

The repository is designed to start as a Flutter MVP and later expand to Android, macOS, Linux, and Web from a shared codebase.

> This app is a wellness and ergonomics guidance tool. It is not a medical diagnosis or treatment device. Users with pain, injury, pregnancy, disability, or medical conditions should follow advice from qualified clinicians.

## Current implementation status

The current Windows MVP has been locally validated with:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

Validated features:

- Flutter Material 3 app shell.
- English/Persian language switch with RTL support for Persian.
- Reminder content loaded from JSON assets in `/content/en` and `/content/fa`.
- Job profile filtering for office/computer, call center, control room, and driver roles.
- Configurable reminder intervals with a 30-second demo option.
- Start, pause, reset, and show-next controls.
- Persistent language/profile/interval preferences.
- Reminder SVG visuals shown in the main reminder card.
- In-app reminder popup overlay with reminder visual, title, body, and safety note.
- Windows system tray behavior: close/minimize hides the app to tray; explicit `Exit` from tray terminates the app.
- Analyzer and test suite pass locally on Windows.

## Desktop behavior

ErgoMove is intended to run as a background ergonomic reminder app.

Required desktop behavior:

- Closing or minimizing the main window should hide the app to the system tray instead of terminating it.
- The tray icon should remain visible while the app is running.
- Tray left-click should restore the app.
- Tray right-click should show a context menu with `Show ErgoMove` and `Exit`.
- The app should fully quit only when the user chooses `Exit` from the tray menu.

The current implementation lives in:

- `lib/desktop_shell_controller.dart`

## Reminder popup direction

Windows native notifications are not the final UX target. ErgoMove should show its own calm popup with the exercise visual.

Current status:

- The app shows an ErgoMove-owned popup overlay inside the Flutter window.

Target behavior:

- The popup should become an independent desktop popup window.
- Default position should be near the Windows clock / system tray.
- The user should later be able to choose the popup position, such as bottom-right, bottom-left, top-right, or top-left.
- The popup should show the same exercise image or animation as the main card.

See:

- `docs/DESKTOP_RUNTIME_BEHAVIOR.md`

## Visual guidance direction

The current SVG illustrations are placeholders. Production visuals should be more natural and preferably animated, similar to ergonomic movement instruction diagrams.

Preferred asset order:

1. Lottie JSON for short looping movement guidance.
2. Animated WebP or GIF where Lottie is not available.
3. Static SVG or PNG as fallback.

See:

- `docs/VISUAL_MOTION_ASSETS.md`

## Core idea

- Show bilingual reminders in English and Persian.
- Let the user choose a job profile: office/computer, call center, security/control room, driver, warehouse/standing work, and custom.
- Run scheduled micro-breaks and longer breaks.
- Show posture tips and low-risk movement prompts.
- Keep content source-based and editable as JSON.
- Start with Windows desktop, then reuse the same Flutter app for Android and macOS.

## Suggested MVP scope

1. Onboarding: language, work hours, job profile, break intensity.
2. Timer engine: 20-minute eye break, 45–60 minute movement break, configurable snooze.
3. Reminder cards: posture, eyes, neck/shoulders, wrists/hands, back/hips, hydration, standing/walking.
4. Content packs: `/content/en/reminders.json` and `/content/fa/reminders.json`.
5. Local settings: no account required.
6. Accessibility: large text, calm notifications, non-scary language.
7. Desktop shell: tray icon, close-to-tray, explicit tray exit.
8. Reminder popup: app-owned desktop popup near the system tray.
9. Visual motion assets: natural movement diagrams and short animations.

## Recommended stack

- Flutter + Dart for shared UI and business logic.
- Windows target first.
- `shared_preferences` for lightweight local settings.
- `tray_manager` for system tray integration.
- `window_manager` for desktop window lifecycle behavior.
- Lottie / animated assets later for natural movement guidance.
- GitHub Actions for analysis/tests.

## Repository structure

```text
.
├── lib/                         # Flutter source
├── content/en/reminders.json     # English reminder content
├── content/fa/reminders.json     # Persian reminder content
├── assets/images/                # Current SVG reminder visuals
├── docs/                         # Product, runtime, visual, roadmap docs
├── scripts/init_github.ps1       # GitHub bootstrap commands
└── .github/workflows/ci.yml      # CI skeleton
```

## Run locally

```powershell
flutter pub get
flutter run -d windows
```

## Validate locally

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

Manual desktop checks:

1. Main window opens normally.
2. Timer starts and counts down.
3. `Show next` changes the reminder card.
4. Reminder visual appears in the card.
5. Reminder popup appears and can be dismissed.
6. Closing the main window hides the app to tray.
7. Minimizing the main window hides the app to tray.
8. Tray icon is visible.
9. Tray left-click restores the main window.
10. Tray right-click opens the context menu.
11. `Exit` from tray terminates the app.

## Create GitHub repository

From inside the project directory:

```powershell
gh auth login
gh repo create ariaPersian/ergomove --private --source . --remote origin --push
```

Alternative repo names:

- `ariaPersian/office-move-reminder`
- `ariaPersian/workfit-reminder`
- `ariaPersian/posture-break-coach`

## License

MIT, unless changed before commercial release.
