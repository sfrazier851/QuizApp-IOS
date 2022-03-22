//
//  SessionManager.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/21/22.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    private init() {}
    private static var loggedInUser: UserModels?
    
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

    
}
