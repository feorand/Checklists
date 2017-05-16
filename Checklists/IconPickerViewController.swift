//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 15.05.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate {
    func iconPicker(controller:IconPickerViewController, didPick iconName:String)
}

class IconPickerViewController: UITableViewController {
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips" ]
    
    var delegate: IconPickerViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell") ?? UITableViewCell()
        cell.imageView!.image = UIImage(named: icons[indexPath.row])
        cell.textLabel!.text = icons[indexPath.row]
        
        return cell
    }
}
