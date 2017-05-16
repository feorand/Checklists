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
    @IBOutlet weak var iconImageView: UIImageView!
    
    var delegate: ChecklistDetailsViewControllerDelegate?
    var checklist: Checklist?
    
    var iconName = "Folder"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textInput.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInput.delegate = self
        
        if let checklist = checklist {
            self.navigationItem.title = "Edit Checklist"
            self.textInput.text = checklist.name
            self.iconName = checklist.iconName
            self.iconImageView.image = UIImage(named: self.iconName)
            doneButton.isEnabled = true
        } else {
            self.navigationItem.title = "New Checklist"
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}

extension ChecklistDetailsViewController {
    @IBAction func CancelPressed() {
        delegate?.checklistDetailsViewControllerDidCancel(self)
    }
    
    @IBAction func DonePressed() {
        let name = textInput.text!
        
        let outChecklist = checklist ?? Checklist(named: name)
        outChecklist.name = name
        outChecklist.iconName = iconName
        
        if checklist != nil {
            delegate?.checklistDetailViewControllerDidFinish(self, withUpdatedItem: outChecklist)
        } else {
            delegate?.checklistDetailViewControllerDidFinish(self, withNewItem: outChecklist)
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

extension ChecklistDetailsViewController: IconPickerViewControllerDelegate {
    func iconPicker(controller: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        self.iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
}

protocol ChecklistDetailsViewControllerDelegate {
    func checklistDetailsViewControllerDidCancel(_ controller: UITableViewController)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withNewItem item: Checklist)
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withUpdatedItem item: Checklist)
}
