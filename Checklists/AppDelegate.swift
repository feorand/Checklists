//
//  AppDelegate.swift
//  Checklists
//
//  Created by Pavel Prokofyev on 28.12.16.
//  Copyright © 2016 pavelprokofyev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataModel = ChecklistsDataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navController = window!.rootViewController as! UINavigationController
        let rootController = navController.viewControllers[0] as! ChecklistsViewController
        rootController.dataModel = self.dataModel
        navController.delegate = rootController
        
        self.handleFirstRun()
        
        let index = ChecklistsDataModel.indexOfCurrentChecklist
        if index >= 0 && index < dataModel.checklists.count {
            let controller = navController.storyboard?.instantiateViewController(withIdentifier: "ChecklistItemsViewController") as! ChecklistItemsViewController
            controller.checklist = dataModel.checklists[index]
            navController.pushViewController(controller, animated: true)
        }
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        dataModel.saveChecklists()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        dataModel.saveChecklists()
    }
}

private extension AppDelegate {
    func handleFirstRun() {
        let isInitialized = UserDefaults.standard.bool(forKey: "IsInitialized")
        if !isInitialized {
            dataModel.seed()
            UserDefaults.standard.set(true, forKey: "IsInitialized")
        }
    }
}

