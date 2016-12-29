//
//  ViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    let thingsToDo = ["Go", "Stand", "Lay", "Fly"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell")!
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = thingsToDo[Int(arc4random_uniform(4))]
        
        return cell
    }
    
}

