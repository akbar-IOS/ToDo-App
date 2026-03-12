//
//  ContentView.swift
//  To-do-App
//
//  Simple To-Do — Main view
//

import SwiftUI

struct TodoListView: View {
    @State private var tasks: [TaskItem] = []
    @State private var newTaskTitle: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Add section at the top
                HStack(spacing: 12) {
                    TextField("Enter a task…", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit { addTask() }

                    Button("Add") {
                        addTask()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()

                List {
                    ForEach(tasks) { task in
                        TaskRow(task: task) {
                            toggleCompletion(for: task)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                    .onMove(perform: moveTasks)
                    
                }
                .toolbar{
                    EditButton()
                }
            }
            .background(Color.white)
            .navigationTitle("To-Do List")
        }
    }
    

    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.append(TaskItem(title: trimmed))
        newTaskTitle = ""
    }

    private func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    private func moveTasks(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Task Row

struct TaskRow: View {
    let task: TaskItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)

                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TodoListView()
}
