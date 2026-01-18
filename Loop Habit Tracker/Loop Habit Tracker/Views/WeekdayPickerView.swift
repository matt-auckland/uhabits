//
//  WeekdayPickerView.swift
//  Loop Habit Tracker
//
//  Created by OpenAI on 18/01/2026.
//

import SwiftUI

struct WeekdayPickerView: View {
    @Binding var selectedWeekdays: Set<Int>

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }

    var body: some View {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let startIndex = calendar.firstWeekday - 1
        let orderedSymbols = Array(symbols[startIndex...] + symbols[..<startIndex])
        let weekdays = Array(1...7)

        HStack(spacing: 8) {
            ForEach(Array(zip(weekdays, orderedSymbols)), id: \.0) { day, symbol in
                Text(symbol)
                    .font(.caption)
                    .frame(width: 32, height: 32)
                    .background(selectedWeekdays.contains(day) ? Color.accentColor.opacity(0.2) : Color.clear)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.secondary.opacity(0.2)))
                    .onTapGesture {
                        toggle(day)
                    }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func toggle(_ day: Int) {
        if selectedWeekdays.contains(day) {
            selectedWeekdays.remove(day)
        } else {
            selectedWeekdays.insert(day)
        }
    }
}

#Preview {
    WeekdayPickerView(selectedWeekdays: .constant(Set(1...7)))
        .padding()
}
