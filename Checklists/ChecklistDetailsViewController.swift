//
//  ChecklistDetailsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 13.04.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistDetailsViewController: UITableViewController {

    @IBOutlet weak var textInput: UITextField!
    var delegate: ChecklistDetailsViewControllerDelegate?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension ChecklistDetailsViewController {
    @IBAction func CancelPressed() {
        delegate?.checklistDetailsViewControllerDidCancel(self)
    }
}

protocol ChecklistDetailsViewControllerDelegate {
    func checklistDetailsViewControllerDidCancel(_ controller: UITableViewController)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withName name:String)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withUpdatedItem item: Checklist)
}
