//
//  Item.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation
import SwiftData

@Model
final class Todo {
    var id = UUID()
    var timestamp: Date
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
    var priority: TodoPriority = TodoPriority.medium
    
    
    init(timestamp: Date = Date(), title: String, dueDate: Date, priority:TodoPriority = .medium, isCompleted: Bool = false) {
        self.timestamp = timestamp
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
    
    var isOverdue: Bool {
        return !isCompleted && dueDate < Date()
    }
    
    var remainingDays:Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
}
