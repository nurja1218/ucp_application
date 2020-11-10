//
//  UserList+CoreDataProperties.swift
//  
//
//  Created by Junsung Park on 2020/11/10.
//
//

import Foundation
import CoreData


extension UserList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserList> {
        return NSFetchRequest<UserList>(entityName: "UserList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var answer: String?
    @NSManaged public var type: String?

}
