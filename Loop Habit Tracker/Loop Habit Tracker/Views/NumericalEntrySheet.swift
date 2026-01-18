//
//  NumericalEntrySheet.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI

struct NumericalEntrySheet: View {
    @Environment(\.dismiss) private var dismiss

    let habit: Habit
    let date: Date
    let existingRepetition: Repetition?
    let onSave: (Double, String?) -> Void
    let onDelete: () -> Void

    @State private var valueText: String
    @State private var notesText: String

    init(
        habit: Habit,
        date: Date,
        existingRepetition: Repetition?,
        onSave: @escaping (Double, String?) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.habit = habit
        self.date = date
        self.existingRepetition = existingRepetition
        self.onSave = onSave
        self.onDelete = onDelete

        let initialValue = existingRepetition?.value ?? 0
        let initialNotes = existingRepetition?.notes ?? ""
        _valueText = State(initialValue: initialValue == 0 ? "" : String(initialValue))
        _notesText = State(initialValue: initialNotes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Value") {
                    TextField("Amount", text: $valueText)
                        .keyboardType(.decimalPad)
                    if !habit.unit.isEmpty {
                        Text("Unit: \(habit.unit)")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notesText, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                if existingRepetition != nil {
                    Section {
                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            Text("Delete Entry")
                        }
                    }
                }
            }
            .navigationTitle("Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let parsedValue = Double(valueText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        onSave(parsedValue, notesText.isEmpty ? nil : notesText)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NumericalEntrySheet(
        habit: Habit(name: "Run", unit: "km", type: .numerical),
        date: Date(),
        existingRepetition: nil,
        onSave: { _, _ in },
        onDelete: {}
    )
    .padding()
}
