//
//  ContentView.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var todos: [Todo]
    @State private var isAddingTodo = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(todos) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteTodos)
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

    private func addTodo() {
        withAnimation {
            let newTodo = Todo(timestamp: Date(), title: "")
            modelContext.insert(newTodo)
        }
    }

    private func deleteTodos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(todos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Todo.self, inMemory: true)
}
