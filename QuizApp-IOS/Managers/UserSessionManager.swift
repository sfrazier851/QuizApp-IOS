//
//  SessionManager.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/21/22.
//

import Foundation

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
            case .inApp:
                loggedInUser = LoginPort.user!
            case .facebook:
                
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
                                
                        
                    URLSession.shared.dataTask(with: requestFirstName) {
                        (data, response, error) in

                        guard let data = data else {
                            print("An error occurred.")
                            return
                        }
                        
                        let receivedJsonString = String(decoding: data, as: UTF8.self)
                        
                        guard !receivedJsonString.isEmpty else {
                            print("An error ocurred.")
                            return
                        }
                        
                        let receivedName = try! Utilities.convertToDictionary(from: receivedJsonString)!["first_name"]
                        let receivedEmail = try! Utilities.convertToDictionary(from: receivedJsonString)!["email"]
                        
                        //UserSessionManager.fbFirstName = receivedName!
                        //UserDefaults.standard.set(receivedName!, forKey: K.UserDefaults.userScreenName)
                        
                        // check if facebook user is already in the database
                        if LoginPort.initLogin.login(S: receivedEmail!, PW: "facebook-user") == true {
                            
                        } else {
                            // user is not already in database, create user
                            DBCRUD.initDBCRUD.createUserWithUserModal(us: UserModels(Email: receivedEmail!, Password: "facebook-user", UserName: receivedName!))
                            LoginPort.initLogin.login(S: receivedEmail!, PW: "facebook-user")
                        }
                        
                        DispatchQueue.main.async {
                            PresenterManager.shared.show(vc: .userHome)
                        }
                    }.resume()
                }
                
            case .none:
                return
        }
    }
    
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
    
    static func endSession() {
        switch UserSessionManager.currentLoginType {
        case .inApp:
            //LoginPort.initLogin.logout()
            PresenterManager.shared.show(vc: .login)
        case .facebook:
            KeychainManager.delete(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)
            UserDefaults.standard.removeObject(forKey: K.UserDefaults.userScreenName)
            PresenterManager.shared.show(vc: .login)
        default:
            return
        }
        currentLoginType = .none
    }
    
}
