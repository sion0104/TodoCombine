//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation
import SwiftData
import Combine

class TodoViewModel: ObservableObject{
    @Published var todos: [Todo] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addTodo(_ todo: Todo) {
        Just(todo)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTodo in
                self?.todos.append(newTodo)
            }
            .store(in: &cancellables)
    }
    
    func addTodoAsync(_ todo: Todo) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.todos.append(todo)
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
