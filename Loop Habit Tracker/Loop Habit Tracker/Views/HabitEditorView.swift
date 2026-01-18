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

    private let habit: Habit?

    @State private var name: String
    @State private var question: String
    @State private var notes: String
    @State private var habitType: HabitType
    @State private var unit: String
    @State private var targetType: TargetType
    @State private var targetValue: String
    @State private var frequencyNumerator: Int
    @State private var frequencyDenominator: Int
    @State private var colorIndex: Int
    @State private var hasReminder: Bool
    @State private var reminderTime: Date
    @State private var selectedWeekdays: Set<Int>

    init(habit: Habit? = nil) {
        self.habit = habit
        _name = State(initialValue: habit?.name ?? "")
        _question = State(initialValue: habit?.question ?? "")
        _notes = State(initialValue: habit?.notes ?? "")
        _habitType = State(initialValue: habit?.type ?? .yesNo)
        _unit = State(initialValue: habit?.unit ?? "")
        _targetType = State(initialValue: habit?.targetType ?? .atLeast)
        let targetValue = habit?.targetValue ?? 0
        _targetValue = State(initialValue: targetValue == 0 ? "" : String(targetValue))
        _frequencyNumerator = State(initialValue: habit?.frequencyNumerator ?? 1)
        _frequencyDenominator = State(initialValue: habit?.frequencyDenominator ?? 1)
        _colorIndex = State(initialValue: habit?.color ?? 0)
        _hasReminder = State(initialValue: habit?.reminder != nil)
        _reminderTime = State(initialValue: habit?.reminder?.timeDate() ?? Date())
        _selectedWeekdays = State(initialValue: habit?.reminder?.weekdaySet() ?? Set(1...7))
    }

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
            .navigationTitle(habit == nil ? "New Habit" : "Edit Habit")
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
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let targetHabit = habit ?? Habit(name: trimmedName)
        targetHabit.name = trimmedName
        targetHabit.question = question
        targetHabit.notes = notes
        targetHabit.type = habitType
        targetHabit.color = colorIndex
        targetHabit.unit = unit
        targetHabit.targetType = targetType
        targetHabit.targetValue = parsedTarget
        targetHabit.frequencyNumerator = frequencyNumerator
        targetHabit.frequencyDenominator = frequencyDenominator
        if hasReminder {
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let reminder = targetHabit.reminder ?? Reminder(
                hour: components.hour ?? 9,
                minute: components.minute ?? 0,
                weekdayMask: weekdayMask(from: selectedWeekdays),
                enabled: true,
                habit: targetHabit
            )
            reminder.hour = components.hour ?? reminder.hour
            reminder.minute = components.minute ?? reminder.minute
            reminder.weekdayMask = weekdayMask(from: selectedWeekdays)
            reminder.enabled = true
            reminder.habit = targetHabit
            targetHabit.reminder = reminder
        } else {
            targetHabit.reminder = nil
        }
        if habit == nil {
            modelContext.insert(targetHabit)
        }
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
