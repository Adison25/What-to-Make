//
//  Constants.swift
//  What to Make
//
//  Created by Adison Emerick on 8/18/21.
//

import UIKit
import FirebaseDatabase

struct Constants {
    
    struct Storyboard {
        
        static let tabBarVC = "tabBarVC"
        
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


func recipeTitleFont() -> UIFont {
    return UIFont(name: "Optima Regular", size: 40)!
}

func tableViewHeaderFont() -> UIFont {
    return UIFont(name: "Optima Regular", size: 30)!
}

func buttonFont() -> UIFont {
    return UIFont(name: "Optima Regular", size: 15)!
}

var filterArr: [String] = []

func addFilter(filter: String) {
    filterArr.append(filter)
    //recipesArr needs to be modified
    filterRecipesArr()
    
}

func removeFilter(filter: String) {
    let modifiedArray = filterArr.filter { $0 != filter }
    filterArr = modifiedArray
//    print(filterArr)
    filterRecipesArr()
}

func filterRecipesArr(){
    modifiedRecipesArr = allRecipes
    var idx = 0
    var hasIt = 0
    for item in allRecipes {
        for filter in item.tags {
            if filterArr.contains(filter) {
                hasIt = 1
            }
        }
        if hasIt == 0 && filterArr.count > 0{
            modifiedRecipesArr.remove(at: idx)
        }else {
            idx += 1
        }
        hasIt = 0
        
    }
}

let recipesRef = Database.database().reference(withPath: "recipes")
var allRecipes: [RecipeItem] = []
var modifiedRecipesArr: [RecipeItem] = []

func fetchData() {
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
            allRecipes = newItems
            modifiedRecipesArr = allRecipes
        }
        else {
            print("No data available")
        }
    }
}


//private let recipesRef = Database.database().reference(withPath: "recipes")
//var items: [RecipeItem] = []
//
//func fetchData() {
//    recipesRef.getData { (error, snapshot) in
//        if let error = error {
//            print("Error getting data \(error)")
//        }
//        else if snapshot.exists() {
//            var newItems: [RecipeItem] = []
//            for child in snapshot.children {
//                if
//                    let snapshot = child as? DataSnapshot,
//                    let recipeItem = RecipeItem(snapshot: snapshot) {
//                    newItems.append(recipeItem)
//                }
//            }
//            self.items = newItems
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//        else {
//            print("No data available")
//        }
//    }
//}
