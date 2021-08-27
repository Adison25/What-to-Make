//
//  Ingredient+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var toIngredients: NSSet?

}

// MARK: Generated accessors for toIngredients
extension Ingredient {

    @objc(addToIngredientsObject:)
    @NSManaged public func addToToIngredients(_ value: RecipeIngredients)

    @objc(removeToIngredientsObject:)
    @NSManaged public func removeFromToIngredients(_ value: RecipeIngredients)

    @objc(addToIngredients:)
    @NSManaged public func addToToIngredients(_ values: NSSet)

    @objc(removeToIngredients:)
    @NSManaged public func removeFromToIngredients(_ values: NSSet)

}

extension Ingredient : Identifiable {

}
