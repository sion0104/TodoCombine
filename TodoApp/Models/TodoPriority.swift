//
//  TodoPriority.swift
//  TodoApp
//
//  Created by 최시온 on 4/11/25.
//

import Foundation
import SwiftUI

enum TodoPriority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

