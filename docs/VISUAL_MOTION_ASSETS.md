# Visual motion assets

ErgoMove reminder content should eventually use more natural motion guidance than the current placeholder SVG icons.

## Target formats

Preferred order:

1. Lottie JSON for short looping motion guidance.
2. Animated WebP or GIF when Lottie production is not available.
3. Static SVG or PNG as a fallback.

## Content rules

- Show one safe movement at a time.
- Keep the movement slow and non-medical.
- Include a short duration label when useful.
- Avoid claiming treatment, diagnosis, or guaranteed pain relief.
- Keep each asset matched to a `reminder.id` and `visual_asset` path in the JSON catalog.

## First motion set

Start with these reminders:

- `eye-20-20-20`
- `posture-neutral-sitting`
- `movement-stand-walk`
- `neck-shoulder-release`
- `wrists-hands-reset`
- `call-center-voice-breath`
- `control-room-scan-posture`

## Validation

Before merging motion assets, run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
```

Manual checks:

1. The reminder card shows the correct motion asset.
2. The corner popup shows the same motion asset.
3. Persian and English reminders remain aligned by `id`.
4. The app still works when minimized to the tray.
