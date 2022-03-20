//
//  Quiz.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/20/22.
//

import Foundation

struct Quiz {
    var id: Int = 0
    var name: String = ""
    var imageName: String = ""
    
    static let quiz = Quiz()
    
    // Convert query result set to Array of Quiz
    static func convert(quizzesResultSet: [[String]]) -> [Quiz]? {
        var quizzes = [Quiz]()
        for quiz_row in quizzesResultSet {
            let columns = quiz_row
            
            var quiz = Quiz()
            quiz.id = Int(columns[0])!
            quiz.name = columns[1]
            quiz.imageName = columns[2]
            
            quizzes.append(quiz)
        }
        return quizzes
    }
    
    static func getAll() -> [Quiz]? {
        return SQLiteDAL.getAllQuizzes()
    }
    
    static func getByName(name: String) -> [Quiz]? {
        return SQLiteDAL.getByName(name: name)
    }
    
    static func create(name: String, imageName: String) -> Bool? {
        return SQLiteDAL.createQuiz(name: name, imageName: imageName)
    }
}
