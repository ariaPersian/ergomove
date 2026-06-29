# ErgoMove — Bilingual Ergonomic Break Reminder

ErgoMove is a Windows-first, cross-platform ergonomic reminder app concept. The product reminds office workers, computer users, and other low-movement roles to take micro-breaks, rest their eyes, stretch safely, hydrate, and correct workstation posture.

The repository is designed to start as a Flutter MVP and later expand to Android, macOS, Linux, and Web from a shared codebase.

> This app is a wellness and ergonomics guidance tool. It is not a medical diagnosis or treatment device. Users with pain, injury, pregnancy, disability, or medical conditions should follow advice from qualified clinicians.

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

## Recommended stack

- Flutter + Dart for shared UI and business logic.
- Windows target first.
- SQLite or Hive later for settings/history.
- GitHub Actions for analysis/tests.

## Repository structure

```text
.
├── lib/                         # Flutter source
├── content/en/reminders.json     # English reminder content
├── content/fa/reminders.json     # Persian reminder content
├── docs/                         # Product, research, roadmap
├── scripts/init_github.ps1       # GitHub bootstrap commands
└── .github/workflows/ci.yml      # CI skeleton
```

## Run locally

```powershell
flutter pub get
flutter run -d windows
```

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
