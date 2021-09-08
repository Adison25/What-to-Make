//
//  LoginViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/17/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    
    var width: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if view.frame.size.width * 0.50 < 320 {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalToConstant: 320)
            ])
            width = 320
        }else {
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
            ])
            width = view.frame.size.width * 0.5
        }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.size.height * 0.10)
        ])
        width = width * 0.5
        setpUpElements()
        setBackgroundImage()
        self.hideKeyboardOnTap()
    }
    
    func setpUpElements() {
        
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        
        errorLabel.alpha = 0
        
        let size = view.frame.size.width * 14 / 414
        
        //Styling the elements
        Utilities.styleTextField(emailTextField, width: width)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        emailTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleTextField(passwordTextField, width: width)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        passwordTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleFilledButton(loginButton)
        loginButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    
        //validate the text fields
        let error = validateFields()
        
        if error != nil {
            
            //there was an error, something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //couldnt sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    //set user default
                    defaults.set(true, forKey: "LoggedIn")
                    let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.loadingVC) as! LoadingViewController)
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
        
    }
    
    // check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns  the error message
    func validateFields() -> String? {
        
        // check that all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if  Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make  sure your password is at least 8 characters, contains a special character and a number."
        }
                
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setBackgroundImage() {
        let background = UIImage(named: "startPhoto1")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

}
