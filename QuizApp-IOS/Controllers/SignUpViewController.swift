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
        errorLabel.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = 10
    
        // Style the elements
        Utilities.styleTextField(usernameTextField, placeHolderString: "username")
        Utilities.styleTextField(emailTextField, placeHolderString: "email")
        Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        Utilities.styleTextField(passwordConfirmTextField, placeHolderString: "confirm password")
        Utilities.styleFilledButton(signUpButton)
        
        usernameTextField.becomeFirstResponder()
    }

}
