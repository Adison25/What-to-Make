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
    static var savedAllRecipes: [RecipeItem] = []
    static var savedModifiedRecipes: [RecipeItem] = []
    
    static var size: CGFloat = 40
    static var buttonActiveArray = [
        [0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0]
    ]
    
    static var buttonActiveArraySaved = [
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

func resetButtonActiveArraySaved() {
    var x = 0
    var y = 0
    for row in Constants.buttonActiveArraySaved {
        for _ in row {
            Constants.buttonActiveArraySaved[x][y] = 0
            y += 1
        }
        x += 1
        y = 0
    }
}

func resetModifiedArray() {
    Constants.modifiedRecipesArr = Constants.allRecipes
}

func resetModifiedArraySaved() {
    Constants.savedModifiedRecipes = Constants.savedAllRecipes
}

var filterArr: [String] = []
var filterArrSaved: [String] = []

func addFilter(filter: String) {
    filterArr.append(filter)
    filterRecipesArr()
}

func addFilterSaved(filter: String) {
    filterArrSaved.append(filter)
    filterRecipesArrSaved()
}

func removeFilter(filter: String) {
    let modifiedArray = filterArr.filter { $0 != filter }
    filterArr = modifiedArray
    filterRecipesArr()
}

func removeFilterSaved(filter: String) {
    let modifiedArray = filterArrSaved.filter { $0 != filter }
    filterArrSaved = modifiedArray
    filterRecipesArrSaved()
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

func filterRecipesArrSaved() {
    Constants.savedModifiedRecipes = Constants.savedAllRecipes
    var idx = 0
    var hasIt = 0
    for item in Constants.savedAllRecipes {
        for filter in item.tags {
            if filterArrSaved.contains(filter) {
                hasIt = 1
            }
        }
        if hasIt == 0 && filterArrSaved.count > 0{
            Constants.savedModifiedRecipes.remove(at: idx)
        }else {
            idx += 1
        }
        hasIt = 0
    }
}
