//
//  helpers.swift
//  What to Make
//
//  Created by Adison Emerick on 8/28/21.
//

import UIKit
import FirebaseDatabase
import CoreData

let defaults = UserDefaults.standard

func fetchData(completion: @escaping ([RecipeItem]) -> Void) {
    let recipesRef = Database.database().reference(withPath: "recipes")
    recipesRef.getData { (error, snapshot) in
        if let error = error {
            print("Error getting data \(error)")
        }
        else if snapshot.exists() {
            var newItems: [RecipeItem] = []
            for child in snapshot.children {
                if
                    let snapshot = child as? DataSnapshot,
                    let recipeItem = RecipeItem(snapshot: snapshot) {
                    newItems.append(recipeItem)
                }
            }
            Constants.allRecipes = newItems
            Constants.modifiedRecipesArr = Constants.allRecipes
            completion(Constants.modifiedRecipesArr)
        }
        else {
            print("No data available")
        }
    }
//    Constants.onTaskFinished = completion
}

func addToCoreData(idx: Int) {
    let item = Constants.modifiedRecipesArr[idx]
    let rec = Recipe(context: Constants.context)
    rec.name = item.name
    rec.key = item.key
    rec.activeTime = item.activeTime
    rec.isSaved = item.isSaved
    rec.yield = item.yield
    rec.difficulty = item.difficulty
    rec.photoURL = item.photoURL
    rec.sourceURL = item.sourceURL
    for it in item.ingredients {
        let ingr = Ingredient(context: Constants.context)
        ingr.name = it
        rec.addToIngredients(ingr)
    }
    for it in item.directions {
        let dir = Direction(context: Constants.context)
        dir.name = it
        rec.addToDirections(dir)
    }
    for it in item.tags {
        let tag = Tag(context: Constants.context)
        tag.name = it
        rec.addToTags(tag)
    }
    
    //save the data
    saveCoreData()
}

func saveCoreData() {
    do {
        try Constants.context.save()
    }catch {
        fatalError("error saving")
    }
}

func updateSavedRecipe(idx: Int, active: Bool) {
    Constants.allRecipes[idx].isSaved = active
    Constants.modifiedRecipesArr[idx].isSaved = active
    do {
        Constants.savedRecipes = try Constants.context.fetch(Recipe.fetchRequest())
    }catch {
        print("error fetching core data")
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}


public class DynamicSizeTableView: UITableView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
