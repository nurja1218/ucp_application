//
//  Command+CoreDataProperties.swift
//  
//
//  Created by Junsung Park on 2020/11/10.
//
//

import Foundation
import CoreData


extension Command {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Command> {
        return NSFetchRequest<Command>(entityName: "Command")
    }

    @NSManaged public var gesture: String?
    @NSManaged public var group: String?
    @NSManaged public var userid: String?

}
