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
    private static var fbFirstName: String?
    
    // create a session and set respective user data
    static func createSession(loginType: loginType) {
        currentLoginType = loginType
        switch loginType {
            case .inApp:
                loggedInUser = LoginPort.user!
            case .facebook:
                fbFirstName = "" // TODO: make network call to get facebook user first name
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
            // TODO: delete access token from keychain
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
