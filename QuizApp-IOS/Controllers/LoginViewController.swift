//
//  SignInViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class LoginViewController: UIViewController {

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
        errorLabel.backgroundColor = .black //UIColor(white: 0.0, alpha: 1.0)
        // Give label border rounded edges
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = 5
        
        // Style the elements
        Utilities.styleTextField(emailTextField, placeHolderString: "email")
        Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        Utilities.styleFilledButton(loginButton)
        
        //forgotPasswordButton.tintColor = K.Color.Blue
        
        emailTextField.becomeFirstResponder()
    }

}
