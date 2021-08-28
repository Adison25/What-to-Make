//
//  Tag+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/28/21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Tag : Identifiable {

}
