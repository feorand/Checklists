//
//  ChecklistsRepo.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 14.04.17.
//  Copyright © 2017 pavelprokofyev. All rights reserved.
//

import Foundation

class ChecklistRepo {
    private static func getStorageFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first
        
        let url = path!.appendingPathComponent("Checklists.plist")
        return url
    }
    
    static func save(checklists: [Checklist]) {
        let storageUrl = getStorageFileURL()
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(checklists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.write(to: storageUrl, atomically: true)
    }
    
    static func load() -> [Checklist]{
        let storageUrl = getStorageFileURL()
        
        if let data = try? Data(contentsOf: storageUrl) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            let checklists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            
            return checklists
        }
        
        return [Checklist]()
    }
}
