//
//  Checklist.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class Checklist {
    var name: String = ""
    var items: [ChecklistItem] = []
    
    init(named name:String) {
        self.name = name
    }
    
    static func Seed(count: Int) -> [Checklist] {
        var items = [Checklist]()
        for i in 1..<count {
            let checklist = Checklist(named: "Checklist\(i)")
            for j in 1..<count {
                checklist.items.append(ChecklistItem(text: "\(j) of \(checklist.name)", checked: false))
            }
            items.append(checklist)
        }
        
        return items
    }
}
