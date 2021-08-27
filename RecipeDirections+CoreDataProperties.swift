//
//  RecipeDirections+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/27/21.
//
//

import Foundation
import CoreData


extension RecipeDirections {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeDirections> {
        return NSFetchRequest<RecipeDirections>(entityName: "RecipeDirections")
    }

    @NSManaged public var toDirection: Direction?
    @NSManaged public var toRecipe: Recipe?

}

extension RecipeDirections : Identifiable {

}
