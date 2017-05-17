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
    
    var dueDate = Date()
    
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
        
        let outItem = passedItem ?? ChecklistItem()
        outItem.text = textField.text!
        outItem.shouldRemind = shouldRemindSwitch.isOn
        outItem.dueDate = self.dueDate
        
        if passedItem != nil {
            delegate?.ItemDetailViewControllerDidFinish(self, withUpdatedItem: outItem)
        } else {
            delegate?.ItemDetailViewControllerDidFinish(self, withNewItem: outItem)
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
            self.title = "Update Item"
            self.textField.text = passedItem.text
            self.shouldRemindSwitch.isOn = passedItem.shouldRemind
            self.dueDate = passedItem.dueDate        }
        
        self.doneButton.isEnabled = !textField.text!.isEmpty
        self.updateDueDateLabel(date: dueDate)
    }
    
    @IBAction func shouldRemindSwitchValueChanged() {
        tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.isHidden = !shouldRemindSwitch.isOn
    }
    
    private func updateDueDateLabel(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        self.dateLabel.text = formatter.string(from: date)
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
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withNewItem item: ChecklistItem)
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withUpdatedItem item: ChecklistItem)
}
