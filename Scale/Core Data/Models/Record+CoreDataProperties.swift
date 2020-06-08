//
//  Record+CoreDataProperties.swift
//  Scale
//
//  Created by mani on 2020-06-07.
//  Copyright © 2020 mani. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var weight: Float

}
