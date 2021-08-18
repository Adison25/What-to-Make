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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpUpElements()
        setBackgroundImage()
        self.hideKeyboardOnTap()
        
    }
    
    func setpUpElements() {
        
        backButton.setTitleColor(.white, for: .normal)
        
        //hide the error label
        errorLabel.alpha = 0
        
        //Styling the elements
        Utilities.styleTextField(firstNameTextField)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        Utilities.styleTextField(lastNameTextField)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        Utilities.styleTextField(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        Utilities.styleTextField(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        Utilities.styleFilledButton(signUpButton)
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
        
        let intialFilterVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.intialFilterVC) as? IntialFilterViewController
        
        view.window?.rootViewController = intialFilterVC
        view.window?.makeKeyAndVisible()
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
