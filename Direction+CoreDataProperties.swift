//
//  Direction+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension Direction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Direction> {
        return NSFetchRequest<Direction>(entityName: "Direction")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Direction : Identifiable {

}
