//
//  SessionManager.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/20/22.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private static var loggedInUser: User?
    
    private init() {}
    
    func setLoggedInUser(user: User) {
        SessionManager.loggedInUser = user
    }
    
    func getLoggedInUser() -> User? {
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
