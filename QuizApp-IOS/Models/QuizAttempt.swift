//
//  QuizAttempt.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/17/22.
//

import Foundation

struct QuizAttempt {
    var id: Int = 0
    var userID: Int = 0
    var quizID: Int = 0
    var score: Float = 0.0
    var date_attempted: String = ""
    
    static let quizAttempt = QuizAttempt()
    
    // Convert quiz attempt result set to Array of QuizAttempt
    static func convert(quizAttemptsResultSet: [[String]]) -> [QuizAttempt]? {
        var quizAttempts = [QuizAttempt]()
        for quizattempt_row in quizAttemptsResultSet {
            let columns = quizattempt_row
            
            var quizAttempt = QuizAttempt()
            quizAttempt.id = Int(columns[0])!
            quizAttempt.userID = Int(columns[1])!
            quizAttempt.quizID = Int(columns[2])!
            quizAttempt.score = Float(columns[3])!
            quizAttempt.date_attempted = columns[4]
            
            quizAttempts.append(quizAttempt)
        }
        return quizAttempts
    }
    
    static func getAll() -> [QuizAttempt]? {
        return SQLiteDAL.getAllQuizAttempts()
    }
    
    static func getByUser(userID: Int) -> [QuizAttempt]? {
        return SQLiteDAL.getQuizAttemptsByUser(userID: userID)
    }
    
    static func getByUserAndQuiz(userID: Int, quizID: Int) -> [QuizAttempt]? {
        return SQLiteDAL.getQuizAttemptsByUserAndQuiz(userID: userID, quizID: quizID)
    }
    
    static func create(userID: Int, quizID: Int, score: Float) -> Bool? {
        return SQLiteDAL.createQuizAttempt(userID: userID, quizID: quizID, score: score)
    }
}
