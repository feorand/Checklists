//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 02.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var passedItem: ChecklistItem?
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ItemDetailViewController {
    @IBAction func cancelPressed() {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func donePressed() {
        if let passedItem = passedItem {
            passedItem.text = textField.text!
            delegate?.ItemDetailViewControllerDidFinish(self, withUpdatedItem: passedItem)
        } else {
            delegate?.ItemDetailViewControllerDidFinish(self, withName: textField.text!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        shouldRemindSwitchValueChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedItem = passedItem {
            title = "Update Item"
            textField.text = passedItem.text
        }
        
        doneButton.isEnabled = !textField.text!.isEmpty
        
    }
    
    @IBAction func shouldRemindSwitchValueChanged() {
            tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.isHidden = !shouldRemindSwitch.isOn
    }

}

extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = (newText.length > 0)
        
        return true
    }
}

protocol ItemDetailViewControllerDelegate: class {
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withName name: String)
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withUpdatedItem item: ChecklistItem)
}
