//
//  ContentView.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var todos: [Todo]
    @State private var isAddingTodo = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(todos) { todo in
                    NavigationLink {
                        Text("Item at \(todo.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(todo.title)
                    }
                }
//                .onDelete(perform: deleteTodos)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { isAddingTodo = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Todo")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: .constant(""), prompt: "Search")
            .sheet(isPresented: $isAddingTodo) {
                AddTodoView()
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: Todo.self, inMemory: true)
}
