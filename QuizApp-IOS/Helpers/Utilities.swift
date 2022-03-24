//
//  Utilities.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import UIKit

class Utilities {
    
    static func convertToDictionary(from text: String) throws -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
    }
    
    static func isValidPassword(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
    }
    
    // UITextField with black background, orange text and blue cursor
    static func styleTextField(_ textfield:UITextField, placeHolderString:String) {
        
        // disable auto capitalize first letter
        textfield.autocapitalizationType = .none
        textfield.textAlignment = .center
        
        // Create the bottom line
        //let bottomLine = CALayer()
        
        //bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 7, width: textfield.frame.width, height: 8)
        
        //bottomLine.backgroundColor = K.Color.Blue.cgColor
        
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: K.Color.Orange,//UIColor.white,
            .font: UIFont.systemFont(ofSize: 30)
        ]
        textfield.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes: attributes)
        
        textfield.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        // Remove border on text field
        textfield.borderStyle = .none
        textfield.layer.cornerRadius = 18.0
        
        textfield.backgroundColor =  UIColor.black
        
        textfield.font = UIFont(name: "Bold", size: 45)
        textfield.textColor = UIColor.white
        // set the cursor color
        textfield.tintColor = K.Color.Blue
        
        // Add the line to the text field
        //textfield.layer.addSublayer(bottomLine)
        
    }
    
    // Blue filled button with black text
    static func styleFilledButton(_ button:UIButton) {
        
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        // Filled rounded corner style
        button.backgroundColor = K.Color.Blue//.withAlphaComponent(0.7)
        
        button.layer.cornerRadius = 25.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = UIColor.black//UIColor.white
    }
    
    // Orange hollow button with border and Orange label
    static func styleHollowButton(_ button:UIButton) {
        
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = K.Color.Orange.cgColor
        button.backgroundColor = UIColor.black
        
        button.layer.cornerRadius = 25.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = K.Color.Orange//UIColor.white
    }
    static func formatDate(date: Date)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat="MMMM dd yyyy"
        return formatter.string(from: date)
    }
    static func formatetoDate(s:String)->Date{
        print("format to date",s)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat="MMMM dd, yyyy"
        return formatter.date(from: s)!
    }
       static func fitTextInsideButton(_ button: UIButton) {
        
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        
    }
    
    static func loadQuiz(Q : QuizModels) -> [[String]] {
        
        var Quiz:[[String]]=[[String]]()
        
        for Quest in Q.Questions!{
            
            let Question:[String] =  [Quest.Question,Quest.choices![0],Quest.choices![1],Quest.choices![2],Quest.choices![3], Quest.Awnser]
                Quiz.append(Question)
            
        }
        
        return Quiz
    }
    
    
    // verify facebook access token
    static func checkTokenValidity(_ accessToken: String) {
        let url = URL(string: K.Network.Facebook.baseGraphAPI+"?access_token=\(accessToken)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            if response.statusCode < 200 || response.statusCode >= 300 {
                print("token invalid or expired")
                UserSessionManager.endSession()
                DispatchQueue.main.async {
                    PresenterManager.shared.show(vc: .initial)
                }
            } else {
                DispatchQueue.main.async {
                    UserSessionManager.createSession(loginType: .facebook)
                }
            }
        }.resume()
    }
    
    static func getURLComponent(named name: String, in items: [URLQueryItem]) -> String? {
        items.first(where: { $0.name == name })?.value
    }
    
    public struct FacebookLoginResponse {
        let grantedPermissionScopes: [String]
        let accessToken: String
        let state: String
    }
    
    static func response(from url: URL) -> FacebookLoginResponse? {
        guard let items = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
              let state = Utilities.getURLComponent(named: "state", in: items),
              let scope = Utilities.getURLComponent(named: "granted_scopes", in: items),
              let accessToken = Utilities.getURLComponent(named: "access_token", in: items)
        else {
            return nil
        }
        let grantedPermissions = scope
            .split(separator: ",")
            .map(String.init)

        return FacebookLoginResponse(
            grantedPermissionScopes: grantedPermissions,
            accessToken: accessToken,
            state: state)
    }
    
    /*
    public struct FacebookLoginResponse {
        let grantedPermissionScopes: [String]
        let code: String
        let state: String
    }
    */
    /*let urlString = "\(baseURLString)" +
             "?client_id=\(facebookAppID)" +
             "&redirect_uri=\(callbackScheme)://authorize" +
             "&scope=\(permissionScopes.joined(separator: ","))" +
             "&response_type=code%20granted_scopes" +
             "&state=\(state)"*/
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

}

