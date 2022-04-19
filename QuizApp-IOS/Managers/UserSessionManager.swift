//
//  SessionManager.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/21/22.
//

import Foundation

// manage User's session for multiple login types
final class UserSessionManager {
    //static let shared = SessionManager()
    private init() {}
    
    enum loginType {
        case inApp
        case facebook
        case none
    }
    
    private static var currentLoginType: loginType = .none
    private static var loggedInUser: UserModels?
    private static var fbFirstName: String? // replace with struct if getting more user fields from facebook
    private static var fbEmail: String?
    
    // create a session and set respective user data
    static func createSession(loginType: loginType) {
        currentLoginType = loginType
        switch loginType {
            // if user logs in via in-app login screen
            case .inApp:
                // set user within db code provided global (loggedin) user object
                loggedInUser = LoginPort.user!
            // if user logs in via facebook login
            case .facebook:
                // if user screen name is saved in user defaults go to user home screen
                if let userScreenName = UserDefaults.standard.string(forKey: K.UserDefaults.userScreenName) {
                    UserSessionManager.fbFirstName = userScreenName
                    PresenterManager.shared.show(vc: .userHome)
                } else {
                    //get access token from keychain
                    let fbAccessToken = String(data: KeychainManager.read(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)!, encoding: .utf8)!
                    
                    // construct request for facebook user's first name
                    let baseURL = URL(string: K.Network.Facebook.baseGraphAPI)
                    let urlWithParams = URL(string: baseURL!.absoluteString + "?fields=first_name,email&access_token=\(fbAccessToken)")
                    let requestFirstName = URLRequest(url: urlWithParams!)
                                
                    // make request for fb user's first name
                    URLSession.shared.dataTask(with: requestFirstName) {
                        (data, response, error) in

                        guard let data = data else {
                            print("An error occurred.")
                            return
                        }
                        // get json response payload as string
                        let receivedJsonString = String(decoding: data, as: UTF8.self)
                        
                        guard !receivedJsonString.isEmpty else {
                            print("An error ocurred.")
                            return
                        }
                        
                        // get name and email from stringified json response
                        let receivedName = try! Utilities.convertToDictionary(from: receivedJsonString)!["first_name"]
                        let receivedEmail = try! Utilities.convertToDictionary(from: receivedJsonString)!["email"]
                        
                        // check if facebook user is already in the database
                        if LoginPort.initLogin.login(S: receivedEmail!, PW: "facebook-user") == true {
                            
                            // prevent user from logging in if they have been blocked
                            if LoginPort.user?.status != "BLOCKED"{
                                K.user_subscription = DBCRUD.initDBCRUD.getUserSubscription(id: (LoginPort.user?.ID)!)
                                DispatchQueue.main.async {
                                    PresenterManager.shared.show(vc: .userHome)}
                                }
                            else{
                                DispatchQueue.main.async {
                                    PresenterManager.shared.show(vc: .login)}
                            }
                            
                        } else {
                            // user is not already in database, create user
                            // and log them in.
                            DBCRUD.initDBCRUD.createUserWithUserModal(us: UserModels(Email: receivedEmail!, Password: "facebook-user", UserName: receivedName!))
                            LoginPort.initLogin.login(S: receivedEmail!, PW: "facebook-user")
                        }
                        // go to user home screen
                        DispatchQueue.main.async {
                            PresenterManager.shared.show(vc: .userHome)
                        }
                    }.resume()
                }
                
            case .none:
                return
        }
    }
    
    // return user screen name for each login/session type
    static func getUserScreenName() -> String {
        switch UserSessionManager.currentLoginType {
            case .inApp:
                return (loggedInUser?.UserName)!
            case .facebook:
                return fbFirstName ?? ""
            default:
                return ""
        }
    }
    
    // called on logout to clear session data
    static func endSession() {
        switch UserSessionManager.currentLoginType {
        case .inApp:
            PresenterManager.shared.show(vc: .login)
        case .facebook:
            // remove access token from keychain
            KeychainManager.delete(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)
            // remove user screen name from user defaults
            UserDefaults.standard.removeObject(forKey: K.UserDefaults.userScreenName)
            PresenterManager.shared.show(vc: .login)
        default:
            return
        }
        currentLoginType = .none
    }
    
}
