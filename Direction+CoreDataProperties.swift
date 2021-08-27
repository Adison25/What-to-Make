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
    @NSManaged public var toDirections: NSSet?

}

// MARK: Generated accessors for toDirections
extension Direction {

    @objc(addToDirectionsObject:)
    @NSManaged public func addToToDirections(_ value: RecipeDirections)

    @objc(removeToDirectionsObject:)
    @NSManaged public func removeFromToDirections(_ value: RecipeDirections)

    @objc(addToDirections:)
    @NSManaged public func addToToDirections(_ values: NSSet)

    @objc(removeToDirections:)
    @NSManaged public func removeFromToDirections(_ values: NSSet)

}

extension Direction : Identifiable {

}
