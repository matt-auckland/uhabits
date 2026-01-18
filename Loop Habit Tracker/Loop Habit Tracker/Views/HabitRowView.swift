//
//  HabitRowView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(habitColor)
                .frame(width: 12, height: 12)
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                if !habit.question.isEmpty {
                    Text(habit.question)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if habit.type == .numerical {
                Text(habit.unit.isEmpty ? "0" : habit.unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var habitColor: Color {
        let palette: [Color] = [
            .red, .orange, .yellow, .green, .mint, .teal,
            .cyan, .blue, .indigo, .purple, .pink, .brown
        ]
        guard !palette.isEmpty else { return .accentColor }
        let index = abs(habit.color) % palette.count
        return palette[index]
    }
}

#Preview {
    HabitRowView(habit: Habit(name: "Read for 20 minutes", question: "Did you read?"))
        .padding()
}
