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
    
    @IBAction func addNewItem() {
        let itemIndex = 0
        
        let newItem = ChecklistItem(text: "New Item", checked: false)
        items.insert(newItem, at: itemIndex)
        
        let indexPaths = [IndexPath(row: itemIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

extension ChecklistsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell")!
        cell.update(item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.checked = !item.checked 

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.update(item: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
