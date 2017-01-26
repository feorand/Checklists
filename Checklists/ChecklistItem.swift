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
    var checked: Bool = false
    
    init(named text:String) {
        self.text = text
    }
    
    static func seed() -> [ChecklistItem] {
        let thingsToDo = ["Go", "Stand", "Lay", "Fly"]
        var items = [ChecklistItem]()
        
        for _ in 1...100 {
            let thingToDo = thingsToDo[Int(arc4random_uniform(UInt32(thingsToDo.count)))]
            items.append(ChecklistItem(named: thingToDo))
        }
        
        return items
    }
}
