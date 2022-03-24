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

    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        hideKeyboardWhenTappedAround()
    }

    private func setupElements() {
        // Hide the error label
        errorLabel.alpha = 0
        errorLabel.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = 10
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0

        // Style the elements
        Utilities.styleTextField(usernameTextField, placeHolderString: "username")
        Utilities.styleTextField(emailTextField, placeHolderString: "email")
        Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        Utilities.styleTextField(passwordConfirmTextField, placeHolderString: "confirm password")
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(backButton)

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
        } else {
            print(DBCRUD.initDBCRUD.EmailToUserID(NE: emailTextField.text!), emailTextField.text!)
            // Check if user already exists (by email)
            if(DBCRUD.initDBCRUD.EmailToUserID(NE: emailTextField.text!) < 0){
                // if user creation unsuccessful, alert
                if DBCRUD.initDBCRUD.createUserWithUserModal(us: UserModels(Email: emailTextField.text!, Password: passwordTextField.text!, UserName: usernameTextField.text!)) == false {
                    let dialogMessage = UIAlertController(title: "Alert", message: "Account Not Successfully Created!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                } else {
                    // if user creation successful, alert, and save logged in user to global
                    // session manager
                    let dialogMessage = UIAlertController(title: "Alert", message: "Account Successfully Created!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
                        // Login user (setting static LoginPort.user)
                        if self.callLoginPort(S: self.emailTextField.text!, PW: self.passwordTextField.text!) {
                            // Add LoginPort.user to SessionManager
                            //SessionManager.shared.setLoggedInUser(user: LoginPort.user!)
                            UserSessionManager.createSession(loginType: .inApp)
                            //print(LoginPort.user!.UserName!)
                            PresenterManager.shared.show(vc: .userHome)
                        } else {
                            PresenterManager.shared.show(vc: .login)
                          }

                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                  }
                //transitionLogin()
            } else {
                showError("Email already has a User")
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

    func callLoginPort(S: String, PW: String) -> Bool {

        return LoginPort.initLogin.login(S: S, PW: PW)

    }

}
