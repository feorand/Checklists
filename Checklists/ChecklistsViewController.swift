//
//  ViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    var items = ChecklistItem.seed(count: 100)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell")!
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        cell.update(checked: item.checked)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.checked = !item.checked

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.update(checked: item.checked)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
