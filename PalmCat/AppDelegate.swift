//
//  AppDelegate.swift
//  PalmCat
//
//  Created by Junsung Park on 2020/10/28.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import CoreData

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    
    var window: NSWindow!
    var controller:ViewController!
    
    lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "Users") // 여기는 파일명을 적어줘요.
        
        let storeURL = URL.storeURL(for: "group.junsoft.data", databaseName: "Users")
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.url = storeURL
        container.persistentStoreDescriptions = [storeDescription]
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error {
                 fatalError("Unresolved error, \((error as NSError).userInfo)")
             }
         })
         return container
     }()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
       
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    func application(_ application: NSApplication, open urls: [URL])
    {
        print("openurl:")
        let desc = urls[0].absoluteString
        let ret = desc.replacingOccurrences(of: "palmcat://", with: "")
        
        if(controller != nil)
        {
            controller.processTouchpanel(touch: Int(ret)!)
        }
 
       // print(Int(ret))
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
