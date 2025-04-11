//
//  ValidationError.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation

enum ValidationError: Error, LocalizedError {
    case emptyTitle
    case titleTooLong
    case pastDueDate
    case none
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Please enter a title"
        case .titleTooLong:
            return "Title is too long (maximum 50 characters)"
        case .pastDueDate:
            return "The deadline must be after today"
        case .none:
            return ""
        }
    }
}

// 여러 유효성 검사 오류를 포함할 수 있는 타입
struct ValidationErrors: Error {
    let errors: [ValidationError]
    
    var localizedDescription: String {
        errors.map { $0.localizedDescription }.joined(separator: "\n")
    }
}
