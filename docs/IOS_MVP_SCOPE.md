# iOS MVP Scope (iPhone-first)

This document defines the initial iOS MVP feature scope for the Loop Habit Tracker iOS app, mapped to the existing Android app. It focuses on iPhone usage only (no tablet optimization yet).

## Goals

- Deliver a **usable iPhone-first habit tracker** with core flows: create habits, check in daily, view progress.
- Match the **essential Android behaviors** for habits, schedules, reminders, and habit strength.
- Defer high-effort or Android-specific functionality to v2+ (widgets, advanced export, automation).

## MVP (v1) Feature Set

### 1) Habit List (Home)

**Scope**
- List all habits.
- Show today’s status and allow quick check-in.
- Show habit color, name, and current streak/score summary.

**Key interactions**
- Tap habit -> open Habit Detail.
- Swipe or tap affordance to complete/uncomplete.

### 2) Habit Detail

**Scope**
- Habit summary and stats (streak, strength/score).
- History view (calendar-style or simple list).
- Edit entry for a day (toggle or numeric input).

**Notes**
- Mirror Android’s concept of history editing and habit score.

### 3) Create / Edit Habit

**Scope**
- Create new habit (yes/no or numerical).
- Fields: name, question, notes, color.
- Schedule: daily or X times per Y days.
- Reminders: time + weekdays.

**Notes**
- Match Android’s frequency model and reminder settings.

### 4) Reminders & Notifications

**Scope**
- Per-habit reminder time + weekday schedule.
- Local notifications only (no server required).
- On notification: open app and mark done.

### 5) Settings (Minimal)

**Scope**
- Theme: light/dark.
- Reminder permissions.
- Export (CSV) basic flow.

### 6) Onboarding

**Scope**
- Simple 2–3 screen intro on first launch.

### 7) About

**Scope**
- App version, license, contributors (basic).

## V2+ (Deferred) Features

### Widgets
- iOS WidgetKit equivalents of Android widgets (checkmark/history/score/streak/frequency/target).
- High effort, better suited after MVP stability.

### Data Export / Import
- Full import and advanced backup/restore UI (beyond CSV).
- Advanced sharing integrations.

### Advanced Automation
- Tasker-style integrations, shortcuts, or external triggers.

### Tablet Layouts
- Optimize UI for iPad multi-column layouts and split view.

## MVP Deliverables (Suggested Milestones)

1. **Data model & persistence** (habits, repetitions, reminders, schedules).
2. **Habit list + check-in** (core daily usage).
3. **Habit detail + history** (progress visibility).
4. **Create/Edit habit** (user can configure habits fully).
5. **Reminders** (local notifications).
6. **Settings + About + Onboarding** (polish & readiness).

## Open Questions

- Use **SwiftData** for persistence.
- History UI: **calendar** (minimum acceptable for MVP).
- CSV export is included in MVP.
