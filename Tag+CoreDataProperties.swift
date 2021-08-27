//
//  Tag+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var toTags: NSSet?

}

// MARK: Generated accessors for toTags
extension Tag {

    @objc(addToTagsObject:)
    @NSManaged public func addToToTags(_ value: RecipeTags)

    @objc(removeToTagsObject:)
    @NSManaged public func removeFromToTags(_ value: RecipeTags)

    @objc(addToTags:)
    @NSManaged public func addToToTags(_ values: NSSet)

    @objc(removeToTags:)
    @NSManaged public func removeFromToTags(_ values: NSSet)

}

extension Tag : Identifiable {

}
