//
//  ContentView.swift
//  Loop Habit Tracker
//
//  Created by Mathew Paul on 18/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt, order: .forward) private var habits: [Habit]

    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailView(habit: habit)
                    } label: {
                        HabitRowView(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addHabit) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "No habits yet",
                        systemImage: "checkmark.circle",
                        description: Text("Tap + to create your first habit.")
                    )
                }
            }
        }
    }

    private func addHabit() {
        withAnimation {
            let habit = Habit(name: "New Habit")
            modelContext.insert(habit)
        }
    }

    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
