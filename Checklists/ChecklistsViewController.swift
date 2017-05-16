//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 21.03.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    var dataModel: ChecklistsDataModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.checklists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChecklistsViewController.makeCell(for: tableView, withIndentifier: "ChecklistCell")
        let checklist = dataModel.checklists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        let countUnfinished = checklist.countNotFinished
        
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "Empty"
        } else if countUnfinished == 0 {
            cell.detailTextLabel!.text = "Finished"
        } else {
            cell.detailTextLabel!.text = "\(countUnfinished) unfinished"
        }
    
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataModel.checklists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: (dataModel.checklists[indexPath.row], indexPath.row))
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "ChecklistDetailNavigationController") as! UINavigationController
        
        let controller = navController.topViewController as! ChecklistDetailsViewController
        controller.checklist = dataModel.checklists[indexPath.row]
        controller.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
}

extension ChecklistsViewController {
    static func makeCell(for tableView: UITableView, withIndentifier identifier: String) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowChecklist":
            let controller = segue.destination as! ChecklistItemsViewController
            let checkTuple = sender as! (Checklist, Int)
            controller.checklist = checkTuple.0
            ChecklistsDataModel.indexOfCurrentChecklist = checkTuple.1
        case "NewChecklist":
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
    
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withNewItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)

        dataModel.checklists.insert(item, at: 0)
        dataModel.sortChecklists()
        
        tableView.reloadData()
    }
    
    func checklistDetailViewControllerDidFinish(_ controller: UITableViewController, withUpdatedItem item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        
        dataModel.sortChecklists()
        
        tableView.reloadData()
    }
}

extension ChecklistsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            ChecklistsDataModel.indexOfCurrentChecklist = -1
        }
    }
}
