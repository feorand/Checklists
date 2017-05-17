//
//  ViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistItemsViewController: UITableViewController {
    var checklist: Checklist!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = checklist.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell")!
        cell.update(item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = checklist.items[indexPath.row]
        item.checked = !item.checked
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.update(item: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ChecklistItemsViewController {
    func add(newItem: ChecklistItem, at itemIndex:Int = 0) {
        checklist.items.insert(newItem, at: itemIndex)
        
        let indexPaths = [IndexPath(row: itemIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        func getController() -> ItemDetailViewController {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController! as! ItemDetailViewController
            return controller
        }
        
        switch segue.identifier {
        case .some("AddItem"):
            let controller = getController()
            controller.delegate = self
            
        case .some("UpdateItem"):
            let controller = getController()
            controller.delegate = self
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            controller.passedItem = checklist.items[index.row]
            
        default:
            break
        }
    }
}

extension ChecklistItemsViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withNewItem item: ChecklistItem) {
        add(newItem: item)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withUpdatedItem item: ChecklistItem) {
        let index = checklist.items.index(of: item)!
        checklist.items[index] = item
        tableView.reloadData()
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ChecklistItemsViewController {
    override func viewDidLoad() {
        self.navigationItem.title = checklist.name
    }
}
