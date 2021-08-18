//
//  IntialViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/17/21.
//

import UIKit

class IntialViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

}
