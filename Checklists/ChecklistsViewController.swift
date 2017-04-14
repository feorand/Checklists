//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    var checklists = ChecklistsViewController.Seed(count: 10)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChecklistsViewController.makeCell(for: tableView, withIndentifier: "ChecklistCell")
        cell.textLabel!.text = checklists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checklists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: checklists[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditChecklist", sender: checklists[indexPath.row])
    }
}

extension ChecklistsViewController {
    static func Seed(count: Int) -> [Checklist] {
        var items = [Checklist]()
        for i in 1..<count {
            items.append(Checklist(named: "Checklist\(i)"))
        }
        
        return items
    }
    
    static func makeCell(for tableView: UITableView, withIndentifier identifier: String) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowChecklist":
            let controller = segue.destination as! ChecklistItemsViewController
            controller.checklist = sender as? Checklist
        case "NewChecklist", "EditChecklist":
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController! as! ChecklistDetailsViewController
            controller.checklist = sender as? Checklist
            controller.delegate = self
        default:
            print("Checklists - Empty Segue")
        }
    }
}

extension ChecklistsViewController: ChecklistDetailsViewControllerDelegate {
    func checklistDetailsViewControllerDidCancel(_ controller: UITableViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withName name: String) {
        controller.dismiss(animated: true, completion: nil)
        
        let insertIndex = checklists.count
        let newList = Checklist(named: name)
        checklists.insert(newList, at: 0)
        
        let indexPath = IndexPath(row: insertIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withUpdatedItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        
        tableView.reloadData()
    }
}
