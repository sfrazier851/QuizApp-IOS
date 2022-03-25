//
//  SignInViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit
import AuthenticationServices


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var loginWithFacebookButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        setupElements()
        //setupShowHidePassword()
        hideKeyboardWhenTappedAround()
        
    }
    
    func setupShowHidePassword() {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        
    }

    @IBAction func refresh(_ sender: UIButton) {
        
        print("hello")
        //print(sender.imageView)
    }
    
    private func setupElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        // Set background color to black
        errorLabel.backgroundColor = .black //UIColor(white: 0.0, alpha: 1.0)
        // Give label border rounded edges
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = 5
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0

        // Style the elements
        Utilities.styleTextField(emailTextField, placeHolderString: "email")
        Utilities.styleTextField(passwordTextField, placeHolderString: "password")
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(backButton)

        forgotPasswordButton.tintColor = UIColor.white//K.Color.Orange
        forgotPasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        forgotPasswordButton.backgroundColor = UIColor.clear//K.Color.Orange//UIColor.lightGray//.withAlphaComponent(0.5)
        forgotPasswordButton.layer.masksToBounds = true
        forgotPasswordButton.layer.cornerRadius = 15

        loginWithFacebookButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        loginWithFacebookButton.setBackgroundImage(UIImage(named: "facebook_login_button"), for: .normal)
        loginWithFacebookButton.layer.masksToBounds = true
        loginWithFacebookButton.layer.cornerRadius = 25
        
        //temporary
//        emailTextField.text = "2@gmail.com"
//        passwordTextField.text = "123Password!"
        emailTextField.becomeFirstResponder()
    
    }

    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {

        // Check that email and password fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please make sure both fields are filled in."
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
        } else {

            // Remove whitespace and new lines from email and password textfield values
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            if LoginPort.initLogin.login(S: email, PW: password){
                // create session (saving logged in user object)
                //UserSessionManager.createSession(loginType: .inApp)
                if LoginPort.user?.admin ?? false {
                    PresenterManager.shared.show(vc: .adminHome)
                } else {
                    K.user_subscription = DBCRUD.initDBCRUD.getUserSubscription(id: (LoginPort.user?.ID)!)
                    PresenterManager.shared.show(vc: .userHome)
                }
            } else{
                showError("Invalid Credentials")
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

    @IBAction func loginWithFacebookButtonTapped(_ sender: Any) {
        let state = UUID().uuidString
        
        let urlString = "\(K.Network.Facebook.oauthBaseURL)" +
                "?client_id=\(K.Network.Facebook.appID)" +
                "&redirect_uri=\(K.Network.Facebook.redirectURI)" +
                "&scope=\(K.Network.Facebook.permissionScopes.joined(separator: ","))" +
                "&response_type=\(K.Network.Facebook.responseType)" +
                "&state=\(state)"
        let url = URL(string: urlString)!

        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: K.Network.Facebook.callbackScheme) {
            [weak self] (url, error) in
            guard error == nil else {
                print(error!)
                return
            }

            guard let receivedURL = URL(string: (url?.absoluteString.replacingOccurrences(of: "#", with: "?"))!),
                  let response = Utilities.response(from: receivedURL) else {

                print("invalid url: \(String(describing: url))")
                return
            }

            guard response.state == state else {
                print("State changed during login! Possible security breach.")
                return
            }

            // You should send the code to your backend
            // service and get regular/long-lived authentication credentials
            // that you use in the rest of your app.
            //print(response.accessToken)//code) // POST code (in body) to backend service
            //self?.sendCodeToServer(response.code)
            
            // save access token to keychain
            KeychainManager.save(response.accessToken.data(using: .utf8)!, service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)
            
            // create facebook user session
            UserSessionManager.createSession(loginType: .facebook)
        }

        session.presentationContextProvider = self
        session.start()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(
        for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
