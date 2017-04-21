//
//  Checklist.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class Checklist: NSObject, NSCoding {
    var name: String = ""
    var items: [ChecklistItem] = []
    
    init(named name:String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as! String
        self.items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    var countNotFinished: Int {
        get {
            return self.items
                .filter(){x in x.checked == false}
                .count
        }
    }
}
