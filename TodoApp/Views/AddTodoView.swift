//
//  AddTodoView.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import SwiftUI
import Combine

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var todoViewModel = TodoViewModel()
    
    @State private var title = ""
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var dueDate = Date()
    @State private var priority: TodoPriority = .medium
    

    var body: some View {
        NavigationView {
            Form {
                Section("Todo information") {
                    TextField("Enter a TItle", text: $title)
                        
                    
                    DatePicker("Due Date",
                               selection: $dueDate,
                               displayedComponents: .date)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(TodoPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancle") { dismiss() },
                trailing: Button("Save") {
                    saveTask()
                }
            )
        }
    }
    
    private func saveTask() {
        guard !title.isEmpty else { return }
        
        let newTodo = Todo(
            timestamp: Date(),
            title: title,
            dueDate: dueDate,
            priority: priority.rawValue
        )
    }
}

#Preview {
    AddTodoView()
}
