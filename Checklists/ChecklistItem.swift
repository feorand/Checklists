//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 23.01.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {

    var text: String
    var checked: Bool
    var itemID: Int
    var shouldRemind: Bool
    var dueDate: Date

    init(text:String = "No name", checked:Bool = false, shouldRemind: Bool = false, dueDate: Date? = nil) {
        self.text = text
        self.checked = checked
        self.itemID = ChecklistsDataModel.getNextItemID()
        self.shouldRemind = shouldRemind
        self.dueDate = dueDate ?? Date()
    }

    required init?(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObject(forKey: "Text") as! String
        self.checked = aDecoder.decodeBool(forKey: "Checked")
        self.itemID = aDecoder.decodeInteger(forKey: "ItemID")
        self.shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        self.dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        super.init()
    }
}

extension ChecklistItem: NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.text, forKey: "Text")
        aCoder.encode(self.checked, forKey: "Checked")
        aCoder.encode(self.itemID, forKey: "ItemID")
        aCoder.encode(self.shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(self.dueDate, forKey: "DueDate")
    }
}
