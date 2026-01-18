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

    func timeDate(using calendar: Calendar = Calendar.current) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(
            from: DateComponents(
                year: components.year,
                month: components.month,
                day: components.day,
                hour: hour,
                minute: minute
            )
        ) ?? Date()
    }

    func weekdaySet() -> Set<Int> {
        guard weekdayMask > 0 else { return [] }
        return Set((1...7).filter { day in
            weekdayMask & (1 << (day - 1)) != 0
        })
    }
}
