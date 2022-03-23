//
//  SignInViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit
import AuthenticationServices

/*
public struct FacebookLoginResponse {
    let grantedPermissionScopes: [String]
    let code: String
    let state: String
}
*/

public struct FacebookLoginResponse {
    let grantedPermissionScopes: [String]
    let accessToken: String
    let state: String
}

class LoginViewController: UIViewController {

    func getComponent(named name: String, in items: [URLQueryItem]) -> String? {
        items.first(where: { $0.name == name })?.value
    }

    func response(from url: URL) -> FacebookLoginResponse? {
        guard let items = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
              let state = getComponent(named: "state", in: items),
              let scope = getComponent(named: "granted_scopes", in: items),
              //let code = getComponent(named: "code", in: items)
              let accessToken = getComponent(named: "access_token", in: items)
        else {
            return nil
        }
        let grantedPermissions = scope
            .split(separator: ",")
            .map(String.init)

        return FacebookLoginResponse(
            grantedPermissionScopes: grantedPermissions,
            //code: code,
            accessToken: accessToken,
            state: state)
    }
    /*
    func sendCodeToServer(_ code: String) {
        let url = URL(string: "https://example.com/login/facebookCode")!
        var request = URLRequest(url: url)
        request.httpBody = code.data(using: .utf8)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) {
            [weak self] (data, response, error) in

            guard let data = data else {
                print("An error ocurred.")
                return
            }

            let receivedToken = String(decoding: data, as: UTF8.self)
            guard !receivedToken.isEmpty else {
                print("An error ocurred.")
                return
            }
            print(receivedToken)
            //self?.store(token: receivedToken)
        }
    }*/

    func checkTokenValidity(_ accessToken: String) {
        let url = URL(string: "https://graph.facebook.com/me?access_token=\(accessToken)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return
            }

            if response.statusCode < 200 || response.statusCode >= 300 {
                print("token invalid or expired")
            }
        }.resume()
    }

    var userIsAdmin = false;

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
        hideKeyboardWhenTappedAround()

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
                SessionManager.shared.setLoggedInUser(user: LoginPort.user!)
                if LoginPort.user?.admin ?? false {
                    PresenterManager.shared.show(vc: .adminHome)
                } else {
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
        let facebookAppID = "3118549225067954"
        let permissionScopes = ["email"]

        let state = UUID().uuidString
        let callbackScheme = "fb" + facebookAppID
        let baseURLString = "https://www.facebook.com/v7.0/dialog/oauth"
        /*let urlString = "\(baseURLString)" +
                 "?client_id=\(facebookAppID)" +
                 "&redirect_uri=\(callbackScheme)://authorize" +
                 "&scope=\(permissionScopes.joined(separator: ","))" +
                 "&response_type=code%20granted_scopes" +
                 "&state=\(state)"*/
        let urlString = "\(baseURLString)" +
                "?client_id=\(facebookAppID)" +
                "&redirect_uri=\(callbackScheme)://authorize/" +
                "&scope=\(permissionScopes.joined(separator: ","))" +
                "&response_type=token%20granted_scopes" +
                "&state=\(state)"
        let url = URL(string: urlString)!

        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) {
            [weak self] (url, error) in
            guard error == nil else {
                print(error!)
                return
            }
            //print(url)

            guard let receivedURL = URL(string: (url?.absoluteString.replacingOccurrences(of: "#", with: "?"))!),
                  let response = self!.response(from: receivedURL) else {

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
            print(response.accessToken)//code) // POST code (in body) to backend service
            //self?.sendCodeToServer(response.code)
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://graph.facebook.com/me?fields=first_name&access_token=\(response.accessToken)")!)) {
                [weak self] (data, response, error) in

                guard let data = data else {
                    print("An error occurred.")
                    return
                }

                let receivedName = String(decoding: data, as: UTF8.self)
                guard !receivedName.isEmpty else {
                    print("An error ocurred.")
                    return
                }
                print(receivedName)
                // save name to session manager facebook user
                DispatchQueue.main.async {
                    PresenterManager.shared.show(vc: .userHome)
                }
            }.resume()
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
