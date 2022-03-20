//
//  QuestionAnswer.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/17/22.
//

import Foundation

struct QuestionAnswer {
    var id: Int = 0
    var quizID: Int = 0
    var question: String = ""
    var answer: String = ""
    var wrong_options: String = ""
    
    static let questionAnswer = QuestionAnswer()
    
    // Convert question answer result set to Array of QuestionAnswer
    static func convert(questionAnswersResultSet: [[String]]) -> [QuestionAnswer]? {
        var questionAnswers = [QuestionAnswer]()
        for questionanswer_row in questionAnswersResultSet {
            let columns = questionanswer_row
            
            var questionAnswer = QuestionAnswer()
            questionAnswer.id = Int(columns[0])!
            questionAnswer.quizID = Int(columns[1])!
            questionAnswer.question = columns[2]
            questionAnswer.answer = columns[3]
            questionAnswer.wrong_options = columns[4]
            
            questionAnswers.append(questionAnswer)
        }
        return questionAnswers
    }
    
    static func getAll() -> [QuestionAnswer]? {
        return SQLiteDAL.getAllQuestionAnswers()
    }
    
    static func getByQuiz(quizID: Int) -> [QuestionAnswer]? {
        return SQLiteDAL.getQuestionAnswersByQuiz(quizID: quizID)
    }
    
    static func create(quizID: Int, question: String, answer: String, wrong_options: String) -> Bool? {
        return SQLiteDAL.createQuestionAnswer(quizID: quizID, question: question, answer: answer, wrong_options: wrong_options)
    }
}
