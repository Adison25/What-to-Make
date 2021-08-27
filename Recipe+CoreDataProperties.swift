//
//  Recipe+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
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
    @NSManaged public var toDirections: NSSet?
    @NSManaged public var toIngredients: NSSet?
    @NSManaged public var toTags: NSSet?

}

// MARK: Generated accessors for toDirections
extension Recipe {

    @objc(addToDirectionsObject:)
    @NSManaged public func addToToDirections(_ value: RecipeDirections)

    @objc(removeToDirectionsObject:)
    @NSManaged public func removeFromToDirections(_ value: RecipeDirections)

    @objc(addToDirections:)
    @NSManaged public func addToToDirections(_ values: NSSet)

    @objc(removeToDirections:)
    @NSManaged public func removeFromToDirections(_ values: NSSet)

}

// MARK: Generated accessors for toIngredients
extension Recipe {

    @objc(addToIngredientsObject:)
    @NSManaged public func addToToIngredients(_ value: RecipeIngredients)

    @objc(removeToIngredientsObject:)
    @NSManaged public func removeFromToIngredients(_ value: RecipeIngredients)

    @objc(addToIngredients:)
    @NSManaged public func addToToIngredients(_ values: NSSet)

    @objc(removeToIngredients:)
    @NSManaged public func removeFromToIngredients(_ values: NSSet)

}

// MARK: Generated accessors for toTags
extension Recipe {

    @objc(addToTagsObject:)
    @NSManaged public func addToToTags(_ value: RecipeTags)

    @objc(removeToTagsObject:)
    @NSManaged public func removeFromToTags(_ value: RecipeTags)

    @objc(addToTags:)
    @NSManaged public func addToToTags(_ values: NSSet)

    @objc(removeToTags:)
    @NSManaged public func removeFromToTags(_ values: NSSet)

}

extension Recipe : Identifiable {

}
