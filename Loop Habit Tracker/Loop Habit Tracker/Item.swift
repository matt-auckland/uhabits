//
//  Item.swift
//  Loop Habit Tracker
//
//  Created by Mathew Paul on 18/01/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
