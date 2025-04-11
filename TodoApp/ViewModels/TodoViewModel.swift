//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation
import SwiftData
import Combine

enum TodoResult {
    case success(Todo)
    case failure(ValidationErrors)
}

class TodoViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    
    @Published var validationErrors: [ValidationError] = []
    @Published var isValid: Bool = false

    @Published var todos: [Todo] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($title, $dueDate)
                  .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                  .flatMap { title, dueDate in
                      TodoValidator.validateTodo(title: title, dueDate: dueDate)
                  }
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] errors in
                      self?.validationErrors = errors
                      self?.isValid = errors.isEmpty
                  }
                  .store(in: &cancellables)
    }
    
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

    func addTodoWithValidation(title: String, dueDate: Date) -> AnyPublisher<Result<Todo, ValidationErrors>, Never> {
        return TodoValidator.validateTodo(title: title, dueDate: dueDate)
            .map { errors -> Result<Todo, ValidationErrors> in
                if errors.isEmpty {
                    let newTodo = Todo(
                        timestamp: Date(),
                        title: title,
                        dueDate: dueDate
                    )
                    return .success(newTodo)
                } else {
                    return .failure(ValidationErrors(errors: errors))
                }
            }
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func validateAndAddTodo(title: String, dueDate: Date) -> AnyPublisher<TodoResult, Never> {
        return addTodoWithValidation(title: title, dueDate: dueDate)
            .map { result -> TodoResult in
                switch result {
                case .success(let todo):
                    self.todos.append(todo)
                    return .success(todo)
                case .failure(let errors):
                    return .failure(errors)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addNewTodo(title: String, dueDate: Date, completion: @escaping (TodoResult) -> Void) {
        validateAndAddTodo(title: title, dueDate: dueDate)
            .sink { result in
                completion(result)
            }
            .store(in: &cancellables)
    }
}



