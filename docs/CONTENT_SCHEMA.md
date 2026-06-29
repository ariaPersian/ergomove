# Reminder Content Schema

Each reminder should be a JSON object with:

```json
{
  "id": "string-kebab-case",
  "category": "eyes | posture | movement | wrists | neck_shoulders | hydration | breathing",
  "job_profiles": ["office_computer"],
  "interval_minutes": 20,
  "duration_seconds": 20,
  "title": "Short title",
  "body": "Clear instruction",
  "safety_note": "Safety limitation"
}
```

Rules:

- Use calm and non-alarming text.
- Avoid promising treatment or cure.
- Avoid movements that require equipment in the base pack.
- Do not tell users to perform movements while driving or operating machinery.
- Mark all clinical/medical claims as requiring expert review.
