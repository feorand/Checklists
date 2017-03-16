//
//  ViewController.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        items = loadItems(from: getStorageFileURL())
    }
    
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
            save(items: items, to: getStorageFileURL())
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        save(items: items, to: getStorageFileURL())
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ChecklistsViewController {
    func getDocumentsDirectory()-> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    func getStorageFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func addNewItem(withName name:String, at itemIndex:Int = 0) {
        let newItem = ChecklistItem(text: name, checked: false)
        items.insert(newItem, at: itemIndex)
        
        let indexPaths = [IndexPath(row: itemIndex, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func save(items: [ChecklistItem], to storageURL: URL) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: storageURL, atomically: true)
    }
    
    func loadItems(from storageURL: URL) -> [ChecklistItem] {
        if let data = try? Data(contentsOf: storageURL) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            if let decodedItems = unarchiver.decodeObject(forKey: "ChecklistItems") as? [ChecklistItem] {
                return decodedItems
            }
        }
        
        return []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        func getController() -> ItemDetailsViewController {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController! as! ItemDetailsViewController
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
            controller.passedItem = items[index.row]
            
        default:
            break
        }
    }
}

extension ChecklistsViewController: ItemDetailsViewControllerDelegate {
    func itemDetailsViewControllerDidCancel(_ controller: ItemDetailsViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsViewControllerDidFinish(_ controller: ItemDetailsViewController, withName name: String) {
        addNewItem(withName: name)
        save(items: items, to: getStorageFileURL())

        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsViewControllerDidFinish(_ controller: ItemDetailsViewController, withUpdatedItem item: ChecklistItem) {
        let index = items.index(of: item)!
        items[index] = item
        save(items: items, to: getStorageFileURL())
        tableView.reloadData()
        
        controller.dismiss(animated: true, completion: nil)
    }
}
