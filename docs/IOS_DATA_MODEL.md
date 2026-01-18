# iOS Data Model Plan (SwiftData)

This document outlines the initial SwiftData model for the iOS MVP, aligned with the Android domain concepts.

## Core Entities

### Habit

- `id` (UUID)
- `name` (String)
- `question` (String)
- `notes` (String)
- `type` (enum: yes_no, numerical)
- `color` (Int or String key to palette)
- `unit` (String, for numerical habits)
- `targetType` (enum: at_least, at_most)
- `targetValue` (Double)
- `frequencyNumerator` (Int)
- `frequencyDenominator` (Int)
- `reminder` (optional relationship)
- `createdAt` (Date)
- `archivedAt` (Date?)

### Repetition

- `id` (UUID)
- `habit` (relationship to Habit)
- `timestamp` (Date)
- `value` (Double?)
- `notes` (String?)

### Reminder

- `id` (UUID)
- `habit` (relationship to Habit)
- `hour` (Int)
- `minute` (Int)
- `weekdayMask` (Int)
- `enabled` (Bool)

## Supporting Types

### Enums

- `HabitType` (yes_no, numerical)
- `TargetType` (at_least, at_most)

### Frequency

- Store as `frequencyNumerator` and `frequencyDenominator` on `Habit` to mirror Android’s model.

## Notes

- SwiftData relationships should support cascading deletes (deleting a habit removes its repetitions and reminder).
- Habit strength/score is derived (not stored) and computed from repetitions + frequency.
- CSV export will map habits and repetitions to separate CSVs or a single combined export.

