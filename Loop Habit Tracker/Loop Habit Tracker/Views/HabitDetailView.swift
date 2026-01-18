//
//  HabitDetailView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Name", value: habit.name)
                if !habit.question.isEmpty {
                    LabeledContent("Question", value: habit.question)
                }
                LabeledContent("Schedule", value: frequencyText)
            }

            Section("Notes") {
                if habit.notes.isEmpty {
                    Text("No notes yet.")
                        .foregroundStyle(.secondary)
                } else {
                    Text(habit.notes)
                }
            }
        }
        .navigationTitle("Habit")
    }

    private var frequencyText: String {
        let numerator = habit.frequencyNumerator
        let denominator = habit.frequencyDenominator
        if numerator == 1 && denominator == 1 {
            return "Every day"
        }
        if denominator == 7 {
            return "\(numerator)x per week"
        }
        return "\(numerator)x per \(denominator) days"
    }
}

#Preview {
    HabitDetailView(
        habit: Habit(
            name: "Meditate",
            question: "Did you meditate?",
            notes: "Keep it short and simple.",
            frequencyNumerator: 3,
            frequencyDenominator: 7
        )
    )
}
