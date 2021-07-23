//
//  RecipeInfoViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 7/22/21.
//

import UIKit

class RecipeInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        //view.addBlurrEffect()
    }

}

extension UIView {

    func addBlurrEffect() {
        let blurEffectView = TSBlurEffectView() // creating a blur effect view
        blurEffectView.intensity = 1 // setting blur intensity from 0.1 to 10
        self.addSubview(blurEffectView) // adding blur effect view as a subview to your view in which you want to use
    }

}
