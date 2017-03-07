//
//  ViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    var items = ChecklistItem.seed(count: 100)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell")!
        cell.update(item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.checked = !item.checked
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.update(item: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ChecklistsViewController {
    func addNewItem(withName name:String, at itemIndex:Int = 0) {
        let newItem = ChecklistItem(text: name, checked: false)
        items.insert(newItem, at: itemIndex)
        
        let indexPaths = [IndexPath(row: itemIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("AddItem"):
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController! as! AddItemViewController
            controller.delegate = self
        case .some("UpdateItem"):
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController! as! AddItemViewController
            controller.delegate = self
            
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            controller.passedItem = items[index.row]
        default:
            break
        }
    }
}

extension ChecklistsViewController: AddItemDelegate {
    func addItemCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItem(_ controller: AddItemViewController, withName name: String) {
        addNewItem(withName: name)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func AddItem(_ controller: AddItemViewController, withItem item: ChecklistItem) {
        let index = items.index(of: item)!
        items[index] = item
        tableView.reloadData()
        
        controller.dismiss(animated: true, completion: nil)
    }
}
