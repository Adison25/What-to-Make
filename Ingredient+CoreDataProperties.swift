//
//  Ingredient+CoreDataProperties.swift
//  What to Make
//
//  Created by Adison Emerick on 8/28/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
