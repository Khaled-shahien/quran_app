# A11Y Smoke Checklist

Updated: 25 March 2026
Owner: QA + Engineering
Status: Active

## Purpose

Provide a lightweight, repeatable accessibility quality gate for every release.
This checklist validates the baseline delivered in Sprint 4:
- semantics coverage
- contrast safety
- dynamic text scaling resilience

## Scope

Run this checklist on core screens:
- Onboarding/Home
- Quran list
- Duas
- Azkar categories
- Azkar details
- Prayer times

## Test Setup

- Device types: one small phone and one large phone.
- Themes: light and dark.
- Locale: Arabic (default), plus one non-Arabic locale if enabled.
- Text scale factors: 1.0, 1.3, 1.6, 2.0.
- Screen reader: TalkBack (Android) or VoiceOver (iOS).

## Pass/Fail Rule

- Pass: all checklist items pass on required screens and configurations.
- Fail: any blocker in semantics, contrast, or text scaling.

## Section A: Semantics and Screen Reader

### A1. Navigation controls
- [ ] Back buttons are announced as actionable controls.
- [ ] Drawer/menu controls are announced with clear labels.
- [ ] Retry buttons are announced with clear intent (reload/retry wording).

### A2. Interactive content
- [ ] Tappable cards are announced as buttons or actionable containers.
- [ ] Important list items announce concise context (name/type/count/time).
- [ ] Toggleable controls announce current state (selected/on/off) where relevant.

### A3. Focus order
- [ ] Focus traversal order follows visual reading order.
- [ ] No focus traps in dialogs, drawers, or bottom sheets.
- [ ] Focus remains visible and reachable for all key actions.

## Section B: Contrast Audit

### B1. Text contrast
- [ ] Body/small text meets at least WCAG AA 4.5:1.
- [ ] Large text (>= 18pt regular or >= 14pt bold) meets at least 3:1.
- [ ] Error and status text remains readable against its background.

### B2. Component contrast
- [ ] Button label/icon contrast is readable in all enabled states.
- [ ] Navigation selected state preserves icon/text visibility.
- [ ] Chips/badges/tags (for example repeat counters) remain readable.

### B3. Theme parity
- [ ] No contrast regressions when switching light/dark themes.
- [ ] No low-contrast combinations introduced by opacity overlays.

## Section C: Dynamic Text Scaling

### C1. Layout stability
- [ ] No clipped/overlapping text at 1.3 and 1.6.
- [ ] No render overflow at 2.0 on core screens.
- [ ] Key headers, labels, and metadata remain visible.

### C2. Content cards and rows
- [ ] Quran list cards keep titles/details readable without breaking layout.
- [ ] Azkar grid/header cards support multiline labels when scaled.
- [ ] Prayer time rows do not clip prayer name or time values.

### C3. Interaction integrity
- [ ] Tap targets stay reachable and not obscured at large text scales.
- [ ] Dialog actions remain visible and operable.

## Evidence Log (Required)

For each release candidate, attach:
- [ ] Device and OS versions used.
- [ ] Screenshots or short recordings for any failure case.
- [ ] Issue links for failures with severity tags.
- [ ] Final sign-off: QA + Engineering.

## Release Gate

Release is blocked if any of these are unresolved:
- Semantics blocker on a critical action.
- Contrast failure on primary reading/action text.
- Text scaling overflow that hides core content or actions.

## Sign-off Template

- Build: ____________________
- Tester: ___________________
- Date: _____________________
- Result: Pass / Fail
- Notes: ____________________
