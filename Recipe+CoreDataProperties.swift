//
//  Recipe+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/28/21.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var activeTime: String?
    @NSManaged public var isSaved: Bool
    @NSManaged public var name: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var key: String?
    @NSManaged public var directions: NSSet?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for directions
extension Recipe {

    @objc(addDirectionsObject:)
    @NSManaged public func addToDirections(_ value: Direction)

    @objc(removeDirectionsObject:)
    @NSManaged public func removeFromDirections(_ value: Direction)

    @objc(addDirections:)
    @NSManaged public func addToDirections(_ values: NSSet)

    @objc(removeDirections:)
    @NSManaged public func removeFromDirections(_ values: NSSet)

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Recipe {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Recipe : Identifiable {

}
