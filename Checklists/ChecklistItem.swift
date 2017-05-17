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

    init(text:String, checked:Bool) {
        self.text = text
        self.checked = checked
        self.itemID = ChecklistsDataModel.getNextItemID()
    }

    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
}

extension ChecklistItem: NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(itemID, forKey: "ItemID")
    }
}
