//
//  AppDelegate.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //DBInit.init()
        
        //NOTE: this recreates the database if already exists.
        // Comment out after first run.
        SQLiteDatabase.createTables()
        
        // Example db usage:
        print()
        print("=======================")
        print("  example db calls:  ")
        print("=======================")
        User.create(username: "insert_user", email: "i@gmail.com", password: "Password!")
        for user in User.getAll()! { print(user) }
        for user in User.getByEmail(email: "admin@gmail.com")! { print(user) }
        
        print("\n=======================")
        print("  creating quiz  ")
        print("=======================")
        Quiz.create(name: "Swift", imageName: "imSwift")
        for quiz in Quiz.getAll()! { print(quiz) }
        
        print("\n=======================")
        print("  creating quiz attempt")
        print("=======================")
        User.create(username: "test", email: "test@gmail.com", password: "Tassword!")
        let userIDForQuizAttempt = User.getByEmail(email: "test@gmail.com")![0].id
        
        let quizIDForQuizAttempt = Quiz.getByName(name: "Java")![0].id
        
        QuizAttempt.create(userID: userIDForQuizAttempt, quizID: quizIDForQuizAttempt, score: 45/60)
        for quizAttempt in QuizAttempt.getAll()! { print(quizAttempt) }
        for quizAttempt in QuizAttempt.getByUser(userID: 1)! { print(quizAttempt) }
        
        print("\n=======================")
        print("creating question answer")
        print("=======================")
        QuestionAnswer.create(quizID: 1, question: "What are the integer primitive types?", answer: "byte, short, int, long", wrong_options: "int, long; double, long, int; short, boolean")
        for questionAnswer in QuestionAnswer.getAll()! { print(questionAnswer) }
        
        //for questionAnswer in QuestionAnswer.getByQuiz(quizID: 1)! { print(questionAnswer) }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

