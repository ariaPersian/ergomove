# Reminder Content Schema

Each reminder should be a JSON object with:

```json
{
  "id": "string-kebab-case",
  "category": "eyes | posture | movement | neck_shoulders | wrists_hands | breathing | attention_posture | driver_mobility",
  "job_profiles": ["office_computer"],
  "interval_minutes": 20,
  "duration_seconds": 20,
  "title": "Short title",
  "body": "Clear instruction",
  "safety_note": "Safety limitation",
  "visual_type": "static_webp | static_svg | lottie",
  "visual_asset": "assets/images/realistic/example_v2.webp",
  "visual_description": "Localized description of the visual action."
}
```

Rules:

- Use calm and non-alarming text.
- Avoid promising treatment or cure.
- Avoid movements that require equipment in the base pack.
- Do not tell users to perform movements while driving or operating machinery.
- Mark all clinical/medical claims as requiring expert review.
- Keep English and Persian records aligned by `id`, `visual_type`, and
  `visual_asset`.
- Localize `visual_description`; do not embed instructional words in shared
  image assets.
- Keep legacy `static_svg` support even when the active catalog uses
  `static_webp`.
