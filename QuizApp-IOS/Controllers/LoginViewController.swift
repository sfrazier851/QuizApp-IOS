//
//  SignInViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userIsAdmin = false;

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
    }
    
    private func setupElements() {
        // Hide the error label
        errorLabel.alpha = 0
        // Set background color to black
        //errorLabel.backgroundColor = .black //UIColor(white: 0.0, alpha: 1.0)
        // Give label border rounded edges
        //errorLabel.layer.masksToBounds = true
        //errorLabel.layer.cornerRadius = 5
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
        
        // Style the elements
        //Utilities.styleTextField(emailTextField, placeHolderString: "email")
        //Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        //Utilities.styleFilledButton(loginButton)
        
        //forgotPasswordButton.tintColor = K.Color.Blue
        
        // temporary
        emailTextField.text = "s@gmail.com"
        passwordTextField.text = "Password!"
        
        emailTextField.becomeFirstResponder()
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that email and password fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please make sure email and password fields are filled in."
        }
        
        //Check if the email is a valid email
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(email: cleanedEmail) == false {
            // email isn't proper format
            return "Please make sure your email is formatted correctly."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidPassword(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters and contains a special character."
        }
        
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Clear the error label
        errorLabel.alpha = 0
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
        
            // Remove whitespace and new lines from email and password textfield values
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var userToLogin: [User]? = User.getByEmail(email: email)
            
            if let userToLoginValue = userToLogin {
                userToLogin = userToLoginValue
                // Email or Password is left blank
                if email == "" || password == "" {
                    showError("Please make sure both fields are filled in.")
                  // Email is not valid email
                } else if !Utilities.isValidEmail(email: email) {
                    showError("Please make sure your email is formatted correctly.")
                  // User already exists
                } else if userToLogin?.count == 0 {
                    showError("That user doesn't exist.")
                } else {
                    // User can be created, then go to logged-in home screen
                    if userToLogin?[0].password == password {
                        if userToLogin?[0].is_admin == true {
                            PresenterManager.shared.show(vc: .adminHome)
                        } else {
                            PresenterManager.shared.show(vc: .userHome)
                        }
                    } else {
                        showError("Incorrect credentials, please try again.")
                    }
                }
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
