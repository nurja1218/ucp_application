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
    var handIndex:Int = 0
    
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
        let ret = desc.replacingOccurrences(of: "palmcat://", with: "") as String
   
        let Index = ret[0..<3]
        let Middle = ret[2..<6]
        let End0 = ret[4..<9]

        var cnt:Int = 0
        /*
        let alert0 = NSAlert()
        alert0.messageText = ret
        alert0.informativeText = "Total"
        alert0.alertStyle = NSAlert.Style.warning
        alert0.addButton(withTitle: "OK")
        alert0.runModal()
            */
 
        if(handIndex % 4 == 1)
        {
            // Index
            for str in Index
            {
                if(str == "1")
                {
                    cnt =  cnt + 1
                }
            }
         
        }
        else if(handIndex % 4 == 2)
        {
            // Middle
            for str in Middle
            {
                if(str == "1")
                {
                    cnt =  cnt + 1
                }
            }
          
            
        }
        else if(handIndex % 4 == 3)
        {
            // End
            for str in End0
            {
                if(str == "1")
                {
                    cnt =  cnt + 1
                }
            }
            
                  
           
        }
     
     //   cnt = 0
        if(controller != nil)
        {
            controller.processTouchpanel(touch: cnt)
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
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}
