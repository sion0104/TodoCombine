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
    var isCompleted: Bool = false
    var priority: Int = 0
    
    
    init(timestamp: Date, title: String) {
        self.timestamp = timestamp
        self.title = ""
    }
}
