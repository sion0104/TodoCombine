//
//  AddTodoView.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import SwiftUI
import SwiftData
import Combine

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var todoViewModel = TodoViewModel()
    
    @State private var priority: TodoPriority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Information")) {
                    TextField("Enter a Title", text: $todoViewModel.title)
                    
                    if let titleError = todoViewModel.validationErrors.first(where: { $0 == .emptyTitle || $0 == .titleTooLong }) {
                        Text(titleError.localizedDescription)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    DatePicker("Due Date", selection: $todoViewModel.dueDate, displayedComponents: .date)
                    
                    if todoViewModel.validationErrors.contains(.pastDueDate) {
                        Text(ValidationError.pastDueDate.localizedDescription)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(TodoPriority.allCases, id: \.self) { priority in
                            Text(priority.title).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    saveTask()
                }
                    .disabled(!todoViewModel.isValid)
            )
        }
    }

    private func saveTask() {
        todoViewModel.addNewTodo(title: todoViewModel.title, dueDate: todoViewModel.dueDate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todo):
                    modelContext.insert(todo)
                    dismiss()
                case .failure(let validationErrors):
                    todoViewModel.validationErrors = validationErrors.errors
                }
            }
        }
    }
}

#Preview {
    AddTodoView()
}
