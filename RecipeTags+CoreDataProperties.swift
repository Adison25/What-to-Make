//
//  RecipeTags+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension RecipeTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeTags> {
        return NSFetchRequest<RecipeTags>(entityName: "RecipeTags")
    }

    @NSManaged public var toRecipe: Recipe?
    @NSManaged public var toTag: Tag?

}

extension RecipeTags : Identifiable {

}
