//
//  TodoValidator.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation
import Combine

class TodoValidator {
    static func validateTitle(_ title: String) -> AnyPublisher<ValidationError?, Never> {
        return Just(title)
            .map { title -> ValidationError? in
                if title.isEmpty {
                    return .emptyTitle
                } else if title.count > 50 {
                    return .titleTooLong
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    static func validateDueDate(_ dueDate: Date) -> AnyPublisher<ValidationError?, Never> {
        return Just(dueDate)
            .map { date -> ValidationError? in
                if date < Date() {
                    return .pastDueDate
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    static func validateTodo(title: String, dueDate: Date) -> AnyPublisher<[ValidationError], Never> {
        return Publishers.CombineLatest(
            validateTitle(title),
            validateDueDate(dueDate)
        )
        .map { titleError, dateError -> [ValidationError] in
            var errors: [ValidationError] = []
            if let titleError = titleError {
                errors.append(titleError)
            }
            if let dateError = dateError {
                errors.append(dateError)
            }
            return errors
        }
        .eraseToAnyPublisher()
    }
}
