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
    @State private var unit = ""
    @State private var targetType: TargetType = .atLeast
    @State private var targetValue = ""
    @State private var frequencyNumerator = 1
    @State private var frequencyDenominator = 1
    @State private var colorIndex = 0
    @State private var hasReminder = false
    @State private var reminderTime = Date()
    @State private var selectedWeekdays: Set<Int> = Set(1...7)

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

                    if habitType == .numerical {
                        TextField("Unit (e.g. minutes)", text: $unit)
                        Picker("Target", selection: $targetType) {
                            Text("At least").tag(TargetType.atLeast)
                            Text("At most").tag(TargetType.atMost)
                        }
                        TextField("Target value", text: $targetValue)
                            .keyboardType(.decimalPad)
                    }
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

                Section("Reminder") {
                    Toggle("Enable reminder", isOn: $hasReminder)
                    if hasReminder {
                        DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        WeekdayPickerView(selectedWeekdays: $selectedWeekdays)
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
        let parsedTarget = Double(targetValue.replacingOccurrences(of: ",", with: ".")) ?? 0
        let habit = Habit(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            question: question,
            notes: notes,
            type: habitType,
            color: colorIndex,
            unit: unit,
            targetType: targetType,
            targetValue: parsedTarget,
            frequencyNumerator: frequencyNumerator,
            frequencyDenominator: frequencyDenominator
        )
        if hasReminder {
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let reminder = Reminder(
                hour: components.hour ?? 9,
                minute: components.minute ?? 0,
                weekdayMask: weekdayMask(from: selectedWeekdays),
                enabled: true,
                habit: habit
            )
            habit.reminder = reminder
        }
        modelContext.insert(habit)
        dismiss()
    }

    private func weekdayMask(from weekdays: Set<Int>) -> Int {
        weekdays.reduce(0) { mask, day in
            mask | (1 << (day - 1))
        }
    }
}

#Preview {
    HabitEditorView()
        .modelContainer(for: Habit.self, inMemory: true)
}
