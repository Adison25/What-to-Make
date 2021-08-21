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
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        setBackgroundImage()
    }
    
    func setUpElements() {
        titleLabel.textColor = .white
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    func setBackgroundImage() {
        let background = UIImage(named: "startScreenPhoto")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    @IBAction func unwindToIntialVC(_ sender: UIStoryboardSegue) {}

}
