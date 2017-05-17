//
//  ChecklistsRepo.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 14.04.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class ChecklistsDataModel {
    
    var checklists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    
    private class func getStorageFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first
        
        let url = path!.appendingPathComponent("Checklists.plist")
        return url
    }
    
    func seed() {
        let firstChecklist = Checklist(named: "First Checklist")
        self.checklists.append(firstChecklist)
    }
    
    func saveChecklists() {
        let storageUrl = ChecklistsDataModel.getStorageFileURL()
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(self.checklists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.write(to: storageUrl, atomically: true)
    }
    
    func loadChecklists() {
        let storageUrl = ChecklistsDataModel.getStorageFileURL()
        
        if let data = try? Data(contentsOf: storageUrl) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            let checklists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            
            self.checklists = checklists
        }
    }
    
    func sortChecklists() {
        self.checklists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
    class func getNextItemID() -> Int {
        let currentNumber = UserDefaults.standard.integer(forKey: "LastItemID")
        UserDefaults.standard.set(currentNumber + 1, forKey: "LastItemID")
        UserDefaults.standard.synchronize()
        return currentNumber + 1
    }
    
    class var indexOfCurrentChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "LastChecklist")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "LastChecklist")
        }
    }
}
