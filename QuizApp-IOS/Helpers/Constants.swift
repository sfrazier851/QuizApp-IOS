//
//  Constants.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//
import UIKit

struct K {
    
    struct UserDefaults {
        static let userScreenName = "loggedInUserScreenName"
    }
    
    struct Keychain {
        struct Facebook {
            static let service = "facebook"
            static let account = "facebook"
            static let kClass = ""
            static let accessToken = "access-token"
        }
    }
    
    struct Network {
        struct Facebook {
            static let appID = "3118549225067954"
            static let oauthBaseURL = "https://www.facebook.com/v7.0/dialog/oauth"
            static let baseGraphAPI = "https://graph.facebook.com/me"
            static let permissionScopes = ["email"]
            static let callbackScheme = "fb"+appID
            static let redirectURI = callbackScheme+"://authorize/"
            static let responseType = "token%20granted_scopes"
        }
    }
    
    struct Color {
        static let Blue = UIColor.init(red: 0/255, green: 123/255, blue: 241/255, alpha: 1.0)
        static let Orange = UIColor.init(red: 251/255, green: 67/255, blue: 30/255, alpha: 1.0)
    }
    
    struct ReuseIdentifier {
        static let selectQuizCollectionViewCell = "cell"
    }
    
    struct StoryboardID {
        static let main = "Main"
        static let loadingViewController = "LoadingViewController"
        static let initialViewController = "InitialViewController"
        static let signUpViewController = "SignUpViewController"
        static let loginViewController = "LoginViewController"
        static let adminHomeViewController = "AdminHomeViewController"
        static let userHomeViewController = "UserHomeViewController"
        static let iosHomeViewController = "IOSHomeViewController"
        static let iosViewController = "IOSViewController"
        static let gameOverViewController = "GameOverViewController"
        static let javaViewController = "JavaViewController"
        static let androidViewController = "AndroidViewController"
        static let viewRankingViewController = "ViewRankingViewController"
        static let viewRankingByTechViewController = "ViewRankingByTechViewController"
    }
    
    //static let dailyAttempt = UserDefaults.standard.integer(forKey: "DailyAttempts")
    static var dailyAttempt = 0
    
    static var ios_gamescore = 0
    
    static var java_gamescore = 0
    
    static var android_gamescore = 0
    
    static var currentPage = ""
    
    static var user_id : Int = 0
    
    static var game_quiz_id : Int = 0
    
}
