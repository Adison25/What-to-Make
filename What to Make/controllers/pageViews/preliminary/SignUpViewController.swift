//
//  SignUpViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/17/21.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
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
        
        //hide the error label
        errorLabel.alpha = 0
        
        let size = view.frame.size.width * 14 / 414
        
        //Styling the elements
        Utilities.styleTextField(firstNameTextField, width: width)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        firstNameTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleTextField(lastNameTextField, width: width)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        lastNameTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleTextField(emailTextField, width: width)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        emailTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleTextField(passwordTextField, width: width)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        passwordTextField.font = UIFont.systemFont(ofSize: size)
        
        Utilities.styleFilledButton(signUpButton)
        signUpButton.titleLabel?.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
    }
    
    // check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns  the error message
    func validateFields() -> String? {
        
        // check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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

    @IBAction func signUpTapped(_ sender: UIButton) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //there was an error, something wrong with the fields, show error message
            showError(error!)
        }else {
            
            // Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the  user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check  for errors
                if err != nil {
                    
                    // there was an error
                    self.showError("Error creating user")
                }
                else {
                    //User was created successfult, now store the email and passwords
                    //not worth it
                }
            }
            //transition to the intial filterview screen
            self.transitionToFilterView()
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToFilterView() {
        
        //set user default
        defaults.set(true, forKey: "LoggedIn")
        let vc = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.loadingVC) as! LoadingViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func setBackgroundImage() {
        let background = UIImage(named: "startPhoto2")
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
