//
//  HabitHistoryCalendarView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI

struct HabitHistoryCalendarView: View {
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
                }
            }
        }
        .padding(.vertical, 4)
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
        let isToday = calendar.isDate(referenceDate, equalTo: dateForDay(day), toGranularity: .day)
        return isToday ? Color.accentColor.opacity(0.2) : Color.clear
    }

    private func dateForDay(_ day: Int) -> Date {
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        return calendar.date(from: DateComponents(year: components.year, month: components.month, day: day)) ?? referenceDate
    }
}

#Preview {
    HabitHistoryCalendarView(referenceDate: Date())
        .padding()
}
