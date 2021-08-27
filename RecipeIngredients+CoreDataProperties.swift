//
//  RecipeIngredients+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension RecipeIngredients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeIngredients> {
        return NSFetchRequest<RecipeIngredients>(entityName: "RecipeIngredients")
    }

    @NSManaged public var toIngredient: Ingredient?
    @NSManaged public var toRecipe: Recipe?

}

extension RecipeIngredients : Identifiable {

}
