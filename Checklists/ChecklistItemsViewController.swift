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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
            save(items: checklist.items, to: getStorageFileURL())
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        save(items: checklist.items, to: getStorageFileURL())
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ChecklistItemsViewController {
    func getDocumentsDirectory()-> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    func getStorageFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func addNewItem(withName name:String, at itemIndex:Int = 0) {
        let newItem = ChecklistItem(text: name, checked: false)
        checklist.items.insert(newItem, at: itemIndex)
        
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
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withName name: String) {
        addNewItem(withName: name)
        save(items: checklist.items, to: getStorageFileURL())

        controller.dismiss(animated: true, completion: nil)
    }
    
    func ItemDetailViewControllerDidFinish(_ controller: ItemDetailViewController, withUpdatedItem item: ChecklistItem) {
        let index = checklist.items.index(of: item)!
        checklist.items[index] = item
        save(items: checklist.items, to: getStorageFileURL())
        tableView.reloadData()
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ChecklistItemsViewController {
    override func viewDidLoad() {
        checklist.items = loadItems(from: getStorageFileURL())
        self.navigationItem.title = checklist.name
    }
}
