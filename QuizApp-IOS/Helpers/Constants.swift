//
//  Constants.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//
import UIKit

struct K {
    
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
    }
    
    //static let dailyAttempt = UserDefaults.standard.integer(forKey: "DailyAttempts")
    static var dailyAttempt = 0
    
    static var ios_gamescore = 0
    
    static var java_gamescore = 0
    
    static var android_gamescore = 0
    
    static var currentPage = ""
    
}
