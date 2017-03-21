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
}
