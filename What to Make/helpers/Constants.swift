//
//  Constants.swift
//  What to Make
//
//  Created by Adison Emerick on 8/18/21.
//

import UIKit

struct Constants {
    
    struct Storyboard {
        
        static let tabBarVC = "tabBarVC"
        static let intialVC = "intialVC"
        static let signUpVC = "SignUp"
        static let loginVC = "loginVC"
        static let loadingVC = "loadingVC"
        
    }
    
    static var allRecipes: [RecipeItem] = []
    static var modifiedRecipesArr: [RecipeItem] = []
    static var savedRecipes: [Recipe] = []
    static var modifiedItmes: [Recipe] = []
    
    static var size: CGFloat = 0
    static var buttonActiveArray = [
        [0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0]
    ]
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

func resetButtonActiveArray() {
    var x = 0
    var y = 0
    for row in Constants.buttonActiveArray {
        for _ in row {
            Constants.buttonActiveArray[x][y] = 0
            y += 1
        }
        x += 1
        y = 0
    }
}

var filterArr: [String] = []

func addFilter(filter: String) {
    filterArr.append(filter)
    filterRecipesArr()
    
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

func removeFilter(filter: String) {
    let modifiedArray = filterArr.filter { $0 != filter }
    filterArr = modifiedArray
    filterRecipesArr()
}

func filterRecipesArr() {
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
