# Visual motion assets

ErgoMove reminder content should use natural visual guidance. The current SVG icons are placeholders and should be replaced or complemented with more realistic movement diagrams and short animations.

## Reference direction

The desired style is closer to ergonomic exercise instruction sheets: clear human posture, numbered or focused movements, and visible start/end direction. The reference image supplied by the product owner shows the intended direction: human exercise diagrams for eyes, shoulders, neck, wrists, back, and seated movement.

## Target formats

Preferred order:

1. Lottie JSON for short looping motion guidance.
2. Animated WebP or GIF when Lottie production is not available.
3. Static SVG or PNG as a fallback.

## Content rules

- Show one safe movement at a time.
- Prefer natural human body diagrams over abstract icons.
- Keep the movement slow and non-medical.
- Include a short duration label when useful.
- Avoid claiming treatment, diagnosis, or guaranteed pain relief.
- Keep each asset matched to a `reminder.id` and `visual_asset` path in the JSON catalog.
- Use the same asset in the main reminder card and the reminder popup.

## Popup visual rules

The popup should show the same movement visual as the main card. For the production desktop popup, the motion asset should be readable at a small size near the system tray.

Popup visuals must therefore be:

- high contrast;
- readable at compact dimensions;
- safe and non-alarming;
- preferably loopable for 10-20 seconds;
- usable without audio.

## First motion set

Start with these reminders:

- `eye-20-20-20`
- `posture-neutral-sitting`
- `movement-stand-walk`
- `neck-shoulder-release`
- `wrists-hands-reset`
- `call-center-voice-breath`
- `control-room-scan-posture`

## Future implementation notes

Candidate package for animated assets:

- `lottie`

Candidate asset locations:

```text
assets/animations/
assets/images/
```

Suggested JSON fields:

```json
{
  "visual_type": "lottie",
  "visual_asset": "assets/animations/neck_shoulders.json",
  "visual_description": "Gentle neck and shoulder release animation."
}
```

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
5. The visual is readable at popup size.
