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
        static let intialVC = "intialVC"
        static let signUpVC = "SignUp"
        static let loginVC = "loginVC"
        
    }
    
    static var allRecipes: [RecipeItem] = []
    static var modifiedRecipesArr: [RecipeItem] = []
    
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

let defaults = UserDefaults.standard

var filterArr: [String] = []

func addFilter(filter: String) {
    filterArr.append(filter)
    filterRecipesArr()
    
}

func removeFilter(filter: String) {
    let modifiedArray = filterArr.filter { $0 != filter }
    filterArr = modifiedArray
    filterRecipesArr()
}

func filterRecipesArr(){
    Constants.modifiedRecipesArr = Constants.allRecipes
    var idx = 0
    var hasIt = 0
    for item in Constants.allRecipes {
        for filter in item.tags {
            if filterArr.contains(filter) {
                hasIt = 1
            }
        }
        if hasIt == 0 && filterArr.count > 0{
            Constants.modifiedRecipesArr.remove(at: idx)
        }else {
            idx += 1
        }
        hasIt = 0
        
    }
}

let recipesRef = Database.database().reference(withPath: "recipes")

func fetchData() {
    recipesRef.getData { (error, snapshot) in
        if let error = error {
            print("Error getting data \(error)")
        }
//        else if snapshot.exists() {
//            var newItems: [RecipeItem] = []
//            for child in snapshot.children {
//                if
//                    let snapshot = child as? DataSnapshot,
//                    let recipeItem = RecipeItem(snapshot: snapshot) {
//                    newItems.append(recipeItem)
//                }
//            }
//
//            Constants.allRecipes = newItems
//            Constants.modifiedRecipesArr = Constants.allRecipes
//        }
        else {
            print("No data available")
        }
    }
}
