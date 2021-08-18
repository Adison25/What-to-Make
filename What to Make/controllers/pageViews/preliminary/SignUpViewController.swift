//
//  SignUpViewController.swift
//  What to Make
//
//  Created by Adison Emerick on 8/17/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setpUpElements()
    }
    
    func setpUpElements() {
        
        //hide the error label
        errorLabel.alpha = 0
        
        //Styling the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
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
            //create the  user
            
            //transition to the intial filterview screen ( modally)
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

}
