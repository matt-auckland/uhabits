//
//  Habit.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var question: String
    var notes: String
    var type: HabitType
    var color: Int
    var unit: String
    var targetType: TargetType
    var targetValue: Double
    var frequencyNumerator: Int
    var frequencyDenominator: Int
    var createdAt: Date
    var archivedAt: Date?

    var reminder: Reminder?

    var repetitions: [Repetition]

    init(
        id: UUID = UUID(),
        name: String,
        question: String = "",
        notes: String = "",
        type: HabitType = .yesNo,
        color: Int = 11,
        unit: String = "",
        targetType: TargetType = .atLeast,
        targetValue: Double = 0,
        frequencyNumerator: Int = 1,
        frequencyDenominator: Int = 1,
        createdAt: Date = Date(),
        archivedAt: Date? = nil,
        reminder: Reminder? = nil,
        repetitions: [Repetition] = []
    ) {
        self.id = id
        self.name = name
        self.question = question
        self.notes = notes
        self.type = type
        self.color = color
        self.unit = unit
        self.targetType = targetType
        self.targetValue = targetValue
        self.frequencyNumerator = frequencyNumerator
        self.frequencyDenominator = frequencyDenominator
        self.createdAt = createdAt
        self.archivedAt = archivedAt
        self.reminder = reminder
        self.repetitions = repetitions
    }

    func currentStreak(referenceDate: Date = Date(), calendar: Calendar = Calendar.current) -> Int {
        var streak = 0
        var date = calendar.startOfDay(for: referenceDate)
        let completedDates = Set(repetitions.compactMap { repetition in
            guard let value = repetition.value ?? (type == .yesNo ? 1 : nil) else { return nil }
            return value > 0 ? calendar.startOfDay(for: repetition.timestamp) : nil
        })
        while completedDates.contains(date) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: date) else {
                break
            }
            date = previous
        }
        return streak
    }
}
