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
        self.accessoryType = item.checked ? .checkmark : .none
        
        let label = self.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}
