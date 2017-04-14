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
    
    static func load() -> [Checklist]{
        let storageUrl = getStorageFileURL()
        return [Checklist]()
    }
}
