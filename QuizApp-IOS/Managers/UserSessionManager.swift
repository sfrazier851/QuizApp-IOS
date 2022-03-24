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
    
    // create a session and set respective user data
    static func createSession(loginType: loginType) {
        currentLoginType = loginType
        switch loginType {
            case .inApp:
                loggedInUser = LoginPort.user!
            case .facebook:
                //get access token from keychain
                let fbAccessToken = String(data: KeychainManager.read(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)!, encoding: .utf8)!
                
                // construct request for facebook user's first name
                // TODO: replace (response.accessToken) with get from keychain call
                let baseURL = URL(string: K.Network.Facebook.baseGraphAPI)
                let urlWithParams = URL(string: baseURL!.absoluteString + "?fields=first_name&access_token=\(fbAccessToken)")
                let requestFirstName = URLRequest(url: urlWithParams!)
                            
                    
                URLSession.shared.dataTask(with: requestFirstName) {
                    (data, response, error) in

                    guard let data = data else {
                        print("An error occurred.")
                        return
                    }
                    
                    let receivedNameJsonString = String(decoding: data, as: UTF8.self)
                    
                    guard !receivedNameJsonString.isEmpty else {
                        print("An error ocurred.")
                        return
                    }
                    
                    let receivedName = try! Utilities.convertToDictionary(from: receivedNameJsonString)!["first_name"]
                    
                    UserSessionManager.fbFirstName = receivedName!
                    
                    DispatchQueue.main.async {
                        PresenterManager.shared.show(vc: .userHome)
                    }
                }.resume()
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
            LoginPort.initLogin.logout()
            PresenterManager.shared.show(vc: .login)
        case .facebook:
            KeychainManager.delete(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account)
            PresenterManager.shared.show(vc: .login)
        default:
            return
        }
        currentLoginType = .none
    }
    
    /*
    func setLoggedInUser(user: UserModels) {
        SessionManager.loggedInUser = user
    }
    
    func getLoggedInUser() -> UserModels? {
        guard let user = SessionManager.loggedInUser else {
            return nil
        }
        return user
    }
    
    
    func logoutUser() {
        SessionManager.loggedInUser = nil
        PresenterManager.shared.show(vc: .login)
    }
    */
}
