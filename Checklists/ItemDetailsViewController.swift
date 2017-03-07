//
//  ItemDetailsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 02.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailsViewControllerDelegate?
    weak var passedItem: ChecklistItem?
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ItemDetailsViewController {
    @IBAction func cancelPressed() {
        delegate?.itemDetailsViewControllerDidCancel(self)
    }
    
    @IBAction func donePressed() {
        if let passedItem = passedItem {
            passedItem.text = textField.text!
            delegate?.itemDetailsViewControllerDidFinish(self, withUpdatedItem: passedItem)
        } else {
            delegate?.itemDetailsViewControllerDidFinish(self, withName: textField.text!)
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
        }
        
        doneButton.isEnabled = !textField.text!.isEmpty
    }
    
}

extension ItemDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = (newText.length > 0)
        
        return true
    }
}

protocol ItemDetailsViewControllerDelegate: class {
    
    func itemDetailsViewControllerDidCancel(_ controller: ItemDetailsViewController)
    
    func itemDetailsViewControllerDidFinish(_ controller: ItemDetailsViewController, withName name: String)
    
    func itemDetailsViewControllerDidFinish(_ controller: ItemDetailsViewController, withUpdatedItem item: ChecklistItem)
}
