# AGENTS.md

## Project intent

Build ErgoMove as a privacy-first, bilingual ergonomic break reminder app.

## Code rules

- Keep UI strings localizable.
- Do not hard-code medical claims.
- Keep reminder content in JSON.
- Prefer simple, testable Dart services for scheduling and content selection.
- Preserve Persian RTL support.

## Safety rules

- Do not describe the app as a medical device.
- Add safety notes to all movement reminders.
- Do not add camera-based posture detection without a privacy review.
