//
//  Repetition.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import Foundation
import SwiftData

@Model
final class Repetition {
    var id: UUID
    var timestamp: Date
    var value: Double?
    var notes: String?

    var habit: Habit?

    init(
        id: UUID = UUID(),
        timestamp: Date,
        value: Double? = nil,
        notes: String? = nil,
        habit: Habit? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
        self.notes = notes
        self.habit = habit
    }
}
