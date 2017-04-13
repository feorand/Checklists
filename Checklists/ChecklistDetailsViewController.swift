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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate: ChecklistDetailsViewControllerDelegate?
    var checklist: Checklist?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textInput.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInput.delegate = self
        self.navigationItem.title = (checklist == nil) ? "New Checklist" : "Edit Checklist"
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ChecklistDetailsViewController {
    @IBAction func CancelPressed() {
        delegate?.checklistDetailsViewControllerDidCancel(self)
    }
    
    @IBAction func DonePressed() {
        let name = textInput.text!
        
        if let checklist = checklist {
            checklist.name = textInput.text!
            delegate?.checklistDetailViewControllerDidFinish(self, withUpdatedItem: checklist)
        } else {
            delegate?.checklistDetailViewControllerDidFinish(self, withName: name)
        }
    }
}

extension ChecklistDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textNsString = textField.text! as NSString
        let text = textNsString.replacingCharacters(in: range, with: string) as NSString
        self.doneButton.isEnabled = (text.length > 0)
        
        return true
    }
}

protocol ChecklistDetailsViewControllerDelegate {
    func checklistDetailsViewControllerDidCancel(_ controller: UITableViewController)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withName name:String)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withUpdatedItem item: Checklist)
}
