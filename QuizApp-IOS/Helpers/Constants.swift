//
//  Constants.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//
import UIKit

struct K {
    
    struct Color {
        static let Blue = UIColor.init(red: 93/255, green: 163/255, blue: 216/255, alpha: 1.0)
    }
    
    struct Segue {
        static let showInitial = "showInitial"
        static let showSignUp = "showSignUp"
        static let backFromSignUp = "backFromSignUp"
        static let showLogin = "showLogin"
        static let backFromLogin = "backFromLogin"
        static let showAdminHome = "showAdminHome"
        static let showUserHome = "showUserHome"
    }
    
    struct StoryboardID {
        static let main = "Main"
        static let signUpViewController = "SignUpViewController"
        static let loginViewController = "LoginViewController"
        static let adminHomeViewController = "AdminHomeViewController"
        static let userHomeViewController = "UserHomeViewController"
    }
    
}
