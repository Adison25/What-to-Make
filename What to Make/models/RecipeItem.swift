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
    var activeTime: String
    let photoURL: String
    let sourceURL: String
    let ingredients: [String]
    let directions: [String]
    let tags: [String]
    var isSaved: Bool
    
    // MARK: Initialize with Raw Data
    init(key: String, name: String, activeTime: String, photoURL: String, sourceURL: String, ingredients: [String], directions: [String], tags: [String], isSaved: Bool) {
        self.ref = nil
        self.key = key
        self.name = name
        self.activeTime = activeTime
        self.photoURL = photoURL
        self.sourceURL = sourceURL
        self.ingredients = ingredients
        self.directions = directions
        self.tags = tags
        self.isSaved = isSaved
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let directions = value["directions"] as? [String],
            let ingredients = value["ingredients"] as? [String],
            let name = value["name"] as? String,
            let activeTime = value["activeTime"] as? String,
            let sourceURL = value["sourceURL"] as? String,
            let photoURL = value["photoURL"] as? String,
            let tags = value["tags"] as? [String]
        else {
            print("Failef")
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.activeTime = activeTime
        self.photoURL = photoURL
        self.sourceURL = sourceURL
        self.ingredients = ingredients
        self.directions = directions
        self.tags = tags
        self.isSaved = false
    }
    
    // MARK: Convert RecipeItem to AnyObject
    func toAnyObject() -> Any {
        return [
            "name": name,
            "activeTime": activeTime,
            "photoURL": photoURL,
            "sourceURL": sourceURL,
            "ingredients": ingredients,
            "directions": directions,
            "tags": tags
        ]
    }
}
