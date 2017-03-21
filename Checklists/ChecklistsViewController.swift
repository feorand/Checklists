//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //Configure the cell...

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension ChecklistsViewController {
    static func getRandom() -> ChecklistItem {
        let thingsToDo = ["Go", "Stand", "Lay", "Fly"]
        let thingToDo = thingsToDo[Int(arc4random_uniform(UInt32(thingsToDo.count)))]
        return ChecklistItem(text: thingToDo, checked: false)
    }
    
    static func seed(items:[ChecklistItem]? = nil, count: Int) -> [ChecklistItem] {
        let newItem = ChecklistsViewController.getRandom()
        
        if let items = items {
            if items.count < count {
                return seed(items: items + [newItem], count: count)
            } else {
                return items
            }
        } else {
            return seed(items: [newItem], count: count)
        }
    }
}
