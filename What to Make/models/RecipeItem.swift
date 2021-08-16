//
//  RecipeItem.swift
//  What to Make
//
//  Created by Adison Emerick on 8/16/21.
//

import Firebase

struct RecipeItem {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let photoURL: String
    let ingredients: [String]
    let directions: [String]
    let tags: [String]
    
    // MARK: Initialize with Raw Data
    init(key: String = "", name: String, photoURL: String, ingredients: [String], directions: [String], tags: [String]) {
        self.ref = nil
        self.key = key
        self.name = name
        self.photoURL = photoURL
        self.ingredients = ingredients
        self.directions = directions
        self.tags = tags
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let photoURL = value["photoURL"] as? String,
            let ingredients = value["ingredients"] as? [String],
            let directions = value["directions"] as? [String],
            let tags = value["tags"] as? [String]
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.photoURL = photoURL
        self.ingredients = ingredients
        self.directions = directions
        self.tags = tags
    }
    
    // MARK: Convert GroceryItem to AnyObject
    func toAnyObject() -> Any {
        return [
            "name": name,
            "photoURL": photoURL,
            "ingredients": ingredients,
            "directions": directions,
            "tags": tags
        ]
    }
}