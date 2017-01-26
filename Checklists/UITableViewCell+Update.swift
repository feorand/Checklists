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
    func update(checked:Bool) {
        self.accessoryType = checked ? .checkmark : .none
    }
}
