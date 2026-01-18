//
//  Reminder.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import Foundation
import SwiftData

@Model
final class Reminder {
    var id: UUID
    var hour: Int
    var minute: Int
    var weekdayMask: Int
    var enabled: Bool

    @Relationship(inverse: \Habit.reminder)
    var habit: Habit?

    init(
        id: UUID = UUID(),
        hour: Int,
        minute: Int,
        weekdayMask: Int,
        enabled: Bool = true,
        habit: Habit? = nil
    ) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.weekdayMask = weekdayMask
        self.enabled = enabled
        self.habit = habit
    }
}
