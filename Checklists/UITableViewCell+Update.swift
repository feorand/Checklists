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
        let textLabel = self.viewWithTag(1000) as! UILabel
        textLabel.text = "\(item.itemID). \(item.text)"
        
        let accessoryLabel = self.viewWithTag(2000) as! UILabel
        accessoryLabel.text = item.checked ? "✔️" : ""
        accessoryLabel.textColor = self.tintColor
    }
}
