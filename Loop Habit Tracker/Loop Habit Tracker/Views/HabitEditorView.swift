//
//  HabitEditorView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI
import SwiftData

struct HabitEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var question = ""
    @State private var notes = ""
    @State private var habitType: HabitType = .yesNo
    @State private var frequencyNumerator = 1
    @State private var frequencyDenominator = 1
    @State private var colorIndex = 0

    private let palette: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal,
        .cyan, .blue, .indigo, .purple, .pink, .brown
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Name", text: $name)
                    TextField("Question", text: $question)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("Type") {
                    Picker("Habit Type", selection: $habitType) {
                        Text("Yes / No").tag(HabitType.yesNo)
                        Text("Numerical").tag(HabitType.numerical)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Schedule") {
                    Stepper("Times: \(frequencyNumerator)", value: $frequencyNumerator, in: 1...7)
                    Stepper("Per days: \(frequencyDenominator)", value: $frequencyDenominator, in: 1...30)
                }

                Section("Color") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(palette.indices, id: \.self) { index in
                                Circle()
                                    .fill(palette[index])
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Circle()
                                            .stroke(index == colorIndex ? Color.primary : .clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        colorIndex = index
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveHabit() {
        let habit = Habit(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            question: question,
            notes: notes,
            type: habitType,
            color: colorIndex,
            frequencyNumerator: frequencyNumerator,
            frequencyDenominator: frequencyDenominator
        )
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    HabitEditorView()
        .modelContainer(for: Habit.self, inMemory: true)
}
