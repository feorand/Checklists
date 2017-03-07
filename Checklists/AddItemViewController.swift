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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var delegate: AddItemDelegate?
    weak var passedItem: ChecklistItem?
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension AddItemViewController {
    @IBAction func cancelPressed() {
        delegate?.addItemCancel(self)
    }
    
    @IBAction func donePressed() {
        if let passedItem = passedItem {
            passedItem.text = textField.text!
            delegate?.AddItem(self, withItem: passedItem)
        } else {
            delegate?.addItem(self, withName: textField.text!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedItem = passedItem {
            title = "Update Item"
            textField.text = passedItem.text
            doneButton.isEnabled = true
        }
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = (newText.length > 0)
        
        return true
    }
}

protocol AddItemDelegate: class {
    
    func addItemCancel(_ controller: AddItemViewController)
    
    func addItem(_ controller: AddItemViewController, withName name: String)
    
    func AddItem(_ controller: AddItemViewController, withItem item: ChecklistItem)
}
