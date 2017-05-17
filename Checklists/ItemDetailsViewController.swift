//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 02.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit
import UserNotifications

class ItemDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dueDate = Date()
    
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var passedItem: ChecklistItem?
    
    var dateLabelCell: UITableViewCell? {
        get {
            return tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        }
    }
    
    var datePickerCell: UITableViewCell? {
        get {
            return tableView.cellForRow(at: IndexPath(row: 2, section: 1))
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            datePickerCell?.isHidden = false
            textField.endEditing(true)
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        self.dueDate = sender.date
        self.updateDueDateLabel(date: dueDate)
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
        
        if shouldRemindSwitch.isOn {
            outItem.scheduleNotification()
        }
        
        if passedItem != nil {
            delegate?.ItemDetailViewControllerDidFinish(self, withUpdatedItem: outItem)
        } else {
            delegate?.ItemDetailViewControllerDidFinish(self, withNewItem: outItem)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        shouldRemindSwitchValueChanged(sender: shouldRemindSwitch)
        dateLabel.textColor = view.tintColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedItem = passedItem {
            self.title = "Update Item"
            self.textField.text = passedItem.text
            self.shouldRemindSwitch.isOn = passedItem.shouldRemind
            self.dueDate = passedItem.dueDate        }
        
        self.doneButton.isEnabled = !self.textField.text!.isEmpty
        self.updateDueDateLabel(date: self.dueDate)
        
        self.datePicker.minimumDate = Date()
        self.datePicker.setDate(self.dueDate, animated: false)
    }
    
    @IBAction func shouldRemindSwitchValueChanged(sender: UISwitch) {
         dateLabelCell?.isHidden = !sender.isOn
        
        if !sender.isOn {
            datePickerCell?.isHidden = true
            dateLabelCell?.isSelected = false
        }
        
        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {granted, error in })
        }
    }
    
    func updateDueDateLabel(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        self.dateLabel.text = formatter.string(from: date)
    }

}

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePickerCell?.isHidden = true
        dateLabelCell?.isSelected = false
    }
    
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
