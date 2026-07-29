# Visual motion assets

ErgoMove reminder content should use natural visual guidance. The original SVG
icons remain as lightweight legacy fallbacks, while the active catalog uses a
consistent set of AI-assisted, semi-realistic WebP movement illustrations.

## Current v2 visual system

The first realistic set covers every current reminder:

- `eye-20-20-20`
- `posture-neutral-sitting`
- `movement-stand-walk`
- `neck-shoulder-release`
- `wrists-hands-reset`
- `call-center-voice-breath`
- `control-room-scan-posture`
- `driver-parking-mobility`

All eight assets:

- use the same worker, clothing, palette, lighting, and warm neutral background;
- avoid embedded words so one image works in both English and Persian;
- use simple directional marks only where they clarify the action;
- are stored at 960 x 640 as compressed static WebP files;
- retain localized semantic descriptions in both content catalogs;
- are non-destructive `v2` additions, so the earlier SVG files remain available.

The source generation prompts use a `scientific-educational` direction with
realistic anatomy, gentle movement, no medical claim, no logo, and no watermark.
AI output is treated as an illustration draft and is checked at compact popup
size before use.

## Reference-informed v3 additions

Four new movement cards extend the pack:

- `shoulder-shrug-release`
- `overhead-reach`
- `seated-side-reach`
- `seated-torso-turn`

The product-owner reference sheet and screen recording were used to identify
the useful instructional pattern: an immediately recognizable start/end pose,
a minimal directional arrow, a visible dose, and short numbered steps. The
reference artwork, text, branding, and watermark are not included in ErgoMove.
The v3 assets are original generations that retain the v2 character and palette.

Instruction text remains outside the image. `dose_label` and
`instruction_steps` are localized in the content catalogs and rendered below
the shared artwork in both the main card and the popup.

## Animated v4 movement guides

The animation pilot and the product-owner image archive informed the first
animated pack. Six reminders now have equivalent woman/man guides:

- `shoulder-shrug-release`
- `seated-side-reach`
- `seated-chest-opener`
- `seated-ankle-flex`
- `sit-to-stand`
- `supported-calf-raise`

Each guide is an original six-frame Animated WebP:

- three columns by two rows were used during generation and review;
- the final file contains six 512 x 512 frames;
- each frame lasts 700 ms, for a 4.2-second loop;
- the selected guide is persisted locally and transferred to the desktop
  popup;
- reduced-motion mode uses a paired static start/peak WebP;
- all words, dose labels, and safety instructions remain in localized UI.

The supplied archive was used only to identify useful movement categories and
clear pose patterns. Its posters, text, logos, watermarks, and artwork are not
included.

## Reference direction

The desired style is closer to ergonomic exercise instruction sheets: clear human posture, numbered or focused movements, and visible start/end direction. The reference image supplied by the product owner shows the intended direction: human exercise diagrams for eyes, shoulders, neck, wrists, back, and seated movement.

## Target formats

Preferred order:

1. Lottie JSON for short looping motion guidance.
2. Animated WebP when Lottie production is not available.
3. Static WebP, SVG, or PNG as a fallback.

For future animation, prefer authored vector or skeletal motion when production
resources allow it. The current Animated WebP pilot uses reviewed six-frame
sequences and paired still fallbacks.

## Content rules

- Show one safe movement at a time.
- Prefer natural human body diagrams over abstract icons.
- Keep the movement slow and non-medical.
- Include a short duration label when useful.
- Prefer a clear start/end pair for movement instructions.
- Keep numbers, durations, and explanatory text in the localized UI rather than
  baking them into the image.
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

## Asset paths

The v2 set lives in:

```text
assets/images/realistic/
```

The v4 animated guides and reduced-motion stills live in:

```text
assets/animations/
```

Both localized catalogs must point to the same asset for the same reminder ID,
while providing their own localized `visual_description`.

## Future implementation notes

Candidate package for future vector-authored animated assets:

- `lottie`

Candidate asset locations:

```text
assets/animations/
assets/images/
```

Suggested JSON fields:

```json
{
  "visual_type": "static_webp",
  "visual_asset": "assets/images/realistic/neck_shoulders_v2.webp",
  "animation_asset": "assets/animations/neck_shoulders_v1.webp",
  "animation_asset_male": "assets/animations/neck_shoulders_male_v1.webp",
  "animation_still_asset": "assets/animations/neck_shoulders_v1_still.webp",
  "animation_still_asset_male": "assets/animations/neck_shoulders_male_v1_still.webp",
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
6. Woman/man selection persists and reaches the popup.
7. Reduced-motion mode shows a still start/peak pair.
