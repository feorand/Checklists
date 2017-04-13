//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    var checklists = ChecklistsViewController.Seed(count: 10)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChecklistsViewController.makeCell(for: tableView, withIndentifier: "ChecklistCell")
        cell.textLabel!.text = checklists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: checklists[indexPath.row])
    }
}

extension ChecklistsViewController {
    static func Seed(count: Int) -> [Checklist] {
        var items = [Checklist]()
        for i in 1..<count {
            items.append(Checklist(named: "Checklist\(i)"))
        }
        
        return items
    }
    
    static func makeCell(for tableView: UITableView, withIndentifier identifier: String) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistItemsViewController
            controller.checklist = sender as! Checklist
        }
    }
}
