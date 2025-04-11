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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
