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
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if view.frame.size.width * 0.50 < 300 {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalToConstant: 300)
            ])
        }else {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
            ])
        }
        setUpElements()
        setBackgroundImage()
    }
    
    func setUpElements() {
        titleLabel.textColor = .white
        titleLabel.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        signUpButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        loginButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
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

    @IBAction func pressedSignUp(_ sender: UIButton) {
        let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.signUpVC) as! SignUpViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func pressedLogin(_ sender: UIButton) {
        let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.loginVC) as! LoginViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func unwindToIntialVC(_ sender: UIStoryboardSegue) {}

}
