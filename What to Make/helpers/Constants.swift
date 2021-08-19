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
//    print(filterArr)
}

func removeFilter(filter: String) {
    let modifiedArray = filterArr.filter { $0 != filter }
    filterArr = modifiedArray
//    print(filterArr)
}

