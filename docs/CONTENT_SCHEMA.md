# Reminder Content Schema

Each reminder should be a JSON object with:

```json
{
  "id": "string-kebab-case",
  "category": "eyes | posture | movement | neck_shoulders | wrists_hands | breathing | attention_posture | driver_mobility | upper_body | lower_body",
  "job_profiles": ["office_computer"],
  "interval_minutes": 20,
  "duration_seconds": 20,
  "title": "Short title",
  "body": "Clear instruction",
  "dose_label": "Hold 5 seconds • repeat 3 times",
  "instruction_steps": [
    "Start in a stable position.",
    "Move slowly within a comfortable range."
  ],
  "safety_note": "Safety limitation",
  "visual_type": "static_webp | static_svg | lottie",
  "visual_asset": "assets/images/realistic/example_v2.webp",
  "visual_description": "Localized description of the visual action.",
  "animation_asset": "assets/animations/example_v1.webp",
  "animation_asset_male": "assets/animations/example_male_v1.webp",
  "animation_still_asset": "assets/animations/example_v1_still.webp",
  "animation_still_asset_male": "assets/animations/example_male_v1_still.webp"
}
```

Rules:

- Use calm and non-alarming text.
- Avoid promising treatment or cure.
- Avoid movements that require equipment in the base pack.
- Do not tell users to perform movements while driving or operating machinery.
- Mark all clinical/medical claims as requiring expert review.
- Give every reminder a localized `dose_label` and at least two concise
  `instruction_steps`.
- Keep English and Persian records aligned by `id`, `visual_type`, and
  `visual_asset`.
- When animation is available, provide all four animation fields. The two
  localized records must point to the same assets.
- Animated WebP files loop only when motion is enabled. The paired still assets
  are required for reduced-motion rendering and loading fallback.
- Localize `visual_description`; do not embed instructional words in shared
  image assets.
- Keep legacy `static_svg` support even when the active catalog uses
  `static_webp`.
