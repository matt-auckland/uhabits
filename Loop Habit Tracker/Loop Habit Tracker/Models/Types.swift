//
//  Types.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import Foundation

enum HabitType: String, Codable, CaseIterable {
    case yesNo
    case numerical
}

enum TargetType: String, Codable, CaseIterable {
    case atLeast
    case atMost
}
