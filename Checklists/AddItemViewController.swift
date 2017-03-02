//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 02.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension AddItemViewController {
    @IBAction func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed() {
        print("Done! New task is \(textField.text!)")
        dismiss(animated: true, completion: nil)
    }
}
