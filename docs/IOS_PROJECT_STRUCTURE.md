# iOS Project Structure (Current)

This document captures the current state of the iOS project within the repository. It is intended as a reference for the upcoming iOS implementation work.

## Root Layout

- `Loop Habit Tracker/`
  - `Loop Habit Tracker/` (main app target)
  - `Loop Habit TrackerTests/` (unit tests)
  - `Loop Habit TrackerUITests/` (UI tests)
  - `Loop Habit Tracker.xcodeproj/` (Xcode project)

## Main App Target (`Loop Habit Tracker/Loop Habit Tracker/`)

### App Entry

- `Loop_Habit_TrackerApp.swift`
  - SwiftUI app entry point.
  - Creates a SwiftData `ModelContainer` with the placeholder `Item` model.

### UI

- `ContentView.swift`
  - Template SwiftUI list with add/delete for `Item` entries.
  - Uses a `NavigationSplitView` with a simple detail placeholder.

### Data Model

- `Item.swift`
  - Placeholder SwiftData `@Model` with a single `timestamp` field.

## Test Targets

- `Loop Habit TrackerTests/Loop_Habit_TrackerTests.swift`
  - Minimal unit test file from the template.
- `Loop Habit TrackerUITests/Loop_Habit_TrackerUITests.swift`
  - Basic UI test stub.
- `Loop Habit TrackerUITests/Loop_Habit_TrackerUITestsLaunchTests.swift`
  - Template launch test.

## Notes

- The iOS project is a standard SwiftUI + SwiftData template and does not yet reflect the Android app’s domain models or UI flows.
- This structure will be replaced with MVP modules (Habits, Reminders, History, Settings, Export) as implementation begins.

