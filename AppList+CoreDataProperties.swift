//
//  AppList+CoreDataProperties.swift
//  
//
//  Created by Junsung Park on 2020/11/11.
//
//

import Foundation
import CoreData


extension AppList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppList> {
        return NSFetchRequest<AppList>(entityName: "AppList")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var group: String?
    @NSManaged public var process: String?
    @NSManaged public var etc: String?

}
