//
//  HabitHistoryCalendarView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI
import SwiftData

struct HabitHistoryCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingEntrySheet = false
    @State private var selectedDate: Date?

    let habit: Habit
    let referenceDate: Date

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(monthTitle)
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }

                ForEach(days, id: \.self) { day in
                    Text(dayText(for: day))
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, minHeight: 28)
                        .background(background(for: day))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .onTapGesture {
                            handleSelection(for: day)
                        }
                }
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingEntrySheet) {
            if let date = selectedDate {
                NumericalEntrySheet(
                    habit: habit,
                    date: date,
                    existingRepetition: repetition(for: date),
                    onSave: { value, notes in
                        saveNumericalRepetition(for: date, value: value, notes: notes)
                    },
                    onDelete: {
                        deleteRepetition(for: date)
                    }
                )
            }
        }
    }

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: referenceDate)
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let startIndex = calendar.firstWeekday - 1
        return Array(symbols[startIndex...] + symbols[..<startIndex])
    }

    private var days: [Int?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday,
              let range = calendar.range(of: .day, in: .month, for: referenceDate)
        else {
            return []
        }

        let padding = (firstWeekday - calendar.firstWeekday + 7) % 7
        let leading = Array(repeating: Optional<Int>.none, count: padding)
        let monthDays = range.map { Optional<Int>($0) }
        return leading + monthDays
    }

    private func dayText(for day: Int?) -> String {
        guard let day else { return "" }
        return "\(day)"
    }

    private func background(for day: Int?) -> Color {
        guard let day else { return .clear }
        let date = dateForDay(day)
        if let repetition = repetition(for: date) {
            if habit.type == .numerical {
                return repetition.value == nil ? Color.accentColor.opacity(0.1) : Color.accentColor.opacity(0.25)
            }
            return Color.accentColor.opacity(0.25)
        }
        let isToday = calendar.isDate(referenceDate, equalTo: date, toGranularity: .day)
        return isToday ? Color.secondary.opacity(0.1) : Color.clear
    }

    private func dateForDay(_ day: Int) -> Date {
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        return calendar.date(from: DateComponents(year: components.year, month: components.month, day: day)) ?? referenceDate
    }

    private func handleSelection(for day: Int?) {
        guard let day else { return }
        let date = dateForDay(day)
        if habit.type == .numerical {
            selectedDate = date
            showingEntrySheet = true
            return
        }
        toggleBooleanRepetition(for: date)
    }

    private func toggleBooleanRepetition(for date: Date) {
        if let repetition = repetition(for: date) {
            modelContext.delete(repetition)
        } else {
            let repetition = Repetition(timestamp: date, habit: habit, value: 1)
            habit.repetitions.append(repetition)
            modelContext.insert(repetition)
        }
    }

    private func saveNumericalRepetition(for date: Date, value: Double, notes: String?) {
        if let repetition = repetition(for: date) {
            repetition.value = value
            repetition.notes = notes
        } else {
            let repetition = Repetition(timestamp: date, value: value, notes: notes, habit: habit)
            habit.repetitions.append(repetition)
            modelContext.insert(repetition)
        }
    }

    private func deleteRepetition(for date: Date) {
        if let repetition = repetition(for: date) {
            modelContext.delete(repetition)
        }
    }

    private func repetition(for date: Date) -> Repetition? {
        habit.repetitions.first { repetition in
            calendar.isDate(repetition.timestamp, equalTo: date, toGranularity: .day)
        }
    }
}

#Preview {
    HabitHistoryCalendarView(habit: Habit(name: "Meditate"), referenceDate: Date())
        .padding()
}
