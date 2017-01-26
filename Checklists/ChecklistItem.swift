//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 23.01.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked: Bool
    
    init(text:String, checked:Bool) {
        self.text = text
        self.checked = checked
    }
    
    static func getRandom() -> ChecklistItem {
        let thingsToDo = ["Go", "Stand", "Lay", "Fly"]
        let thingToDo = thingsToDo[Int(arc4random_uniform(UInt32(thingsToDo.count)))]
        return ChecklistItem(text: thingToDo, checked: false)
    }
    
    static func seed(items:[ChecklistItem]? = nil, count: Int) -> [ChecklistItem] {
        let newItem = ChecklistItem.getRandom()
        
        if let items = items {
            if items.count < count {
                return seed(items: items + [newItem], count: count)
            } else {
                return items
            }
        } else {
            return seed(items: [newItem], count: count)
        }
    }
}
