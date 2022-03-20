//
//  SignUpViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
    }
    
    private func setupElements() {
        // Hide the error label
        errorLabel.alpha = 0
        //errorLabel.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        //errorLabel.layer.masksToBounds = true
        //errorLabel.layer.cornerRadius = 10
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
    
        // Style the elements
        //Utilities.styleTextField(usernameTextField, placeHolderString: "username")
        //Utilities.styleTextField(emailTextField, placeHolderString: "email")
        //Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        //Utilities.styleTextField(passwordConfirmTextField, placeHolderString: "confirm password")
        //Utilities.styleFilledButton(signUpButton)
        
        usernameTextField.becomeFirstResponder()
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that username, email, password and confirm password fields are filled in
        if  usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordConfirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please make sure all fields are filled in."
        }
        
        //Check if username has already been taken
        let cleanedUsername = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if User.getByUsername(username: cleanedUsername)!.count > 0 {
            return "Sorry, that username has been used already."
        }
        
        //Check if the email is a valid email
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            // email isn't proper format
            return "Please make sure your email is formatted correctly."
        }
        
        // Check if the password is secure
        let password = passwordTextField.text! //.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidPassword(password) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters and contains a special character."
        }
        
        // Check that password and confirm password matches
        let confirmPassword = passwordConfirmTextField.text! //.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password != confirmPassword {
            return "Passwords don't match. Please try again."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Clear the error label
        errorLabel.alpha = 0
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            /*
            var firstName: String?
            var lastName: String?
            // Create cleaned versions of the data
            if let firstNameValue = firstNameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                firstName = firstNameValue
            } else { firstName = "" }
            if let lastNameValue = lastNameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                lastName = lastNameValue
            } else { lastName = "" }
            */
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // check if user with email already exists
            if User.getByEmail(email: email)!.count == 0 {
                // user does not already exist
                // Create the user
                User.create(username: username, email: email, password: password)
                PresenterManager.shared.show(vc: .login)
            }
            else {
                // user email already exists
                showError("That user with email: \(email) already exists.")
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(vc: .initial)
    }
    
}
