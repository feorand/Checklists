//
//  UITableViewCell+Update.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 26.01.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func update(item: ChecklistItem) {
        
        let accessoryText = item.checked ? "✔️ " : ""
        self.textLabel?.text = accessoryText + "\(item.text)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateText = formatter.string(from: item.dueDate)
        
        self.detailTextLabel?.text = item.shouldRemind ? "Due: \(dateText)" : ""
    }
}
