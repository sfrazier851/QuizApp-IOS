//
//  cSQLiteDAL.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/19/22.
//

import Foundation
import SQLite3

class SQLiteDAL {
    
    // return array of types, for class properties
    // in order of declaration
    static func getColumnTypes(modelType: Any) -> [String] {
        let mirror = Mirror(reflecting: modelType)
        var columnTypes = [String]()
        
        for prop in mirror.children {
            columnTypes.append(String(describing: type(of: prop.value)))
        }
        return columnTypes
    }
    
    // general purpose query (NOTE: QUERY MUST RETURN ALL FIELDS OF TABLE!)
    static func query(modelType: Any, queryString: String) -> [[String]]? {
        guard let db = SQLiteDatabase.getDatabase() else {
            return nil
        }
        
        let columnTypes = getColumnTypes(modelType: modelType)
        
        // initialize the result set array of arrays ( rows : [ columns [] ]  )
        var rowsArr = [[String]]()
        var columnsArr = [String]()
        
        var stmt: OpaquePointer?
        
        //prepare query
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("error running query: \(error)")
            exit(1)
        }
        
        // iterate through result set rows
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            var i = 0
            // iterate through columns
            while i < columnTypes.count {
                var column: String
                
                switch columnTypes[i] {
                    case "Float":
                        column = String(sqlite3_column_double(stmt, Int32(i)))
                    case "Int":
                        column = String(sqlite3_column_int(stmt, Int32(i)))
                    case "Bool":
                        column = String(sqlite3_column_int(stmt, Int32(i)))
                    default: //String
                        column = String(cString: sqlite3_column_text(stmt, Int32(i)))
                }
                columnsArr.append(column)
                i += 1
            }
            rowsArr.append(columnsArr)
            // clear columns array for next row
            columnsArr.removeAll()
        }
        // delete compiled statment to avoid resource leaks
        sqlite3_finalize(stmt)
        return rowsArr
    }
    
    // User DAL (getAllUsers, getUsersByEmail, createUser)
    static func getAllUsers() -> [User]? {
        guard let usersResultSet = query(modelType: User.user, queryString: "SELECT * FROM User;") else {
            return nil
        }
        return User.convert(usersResultSet: usersResultSet)
    }
    
    static func getUsersByEmail(email: String) -> [User]? {
        guard let usersResultSet = query(modelType: User.user, queryString: "SELECT * FROM User WHERE email = '\(email)';") else {
            return nil
        }
        return User.convert(usersResultSet: usersResultSet)
    }
    
    static func getUsersByUsername(username: String) -> [User]? {
        guard let usersResultSet = query(modelType: User.user, queryString: "SELECT * FROM User WHERE username = '\(username)';") else {
            return nil
        }
        return User.convert(usersResultSet: usersResultSet)
    }
    
    static func createUser(username: String, email: String, password: String) -> Bool? {
        guard let db = SQLiteDatabase.getDatabase() else {
            return nil
        }
        var success = true
        let insertStatementString = "INSERT INTO User ( username, email, password ) VALUES ( ?, ?, ? )"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, NSString(string: username).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: email).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: password).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nINSERT statement is not prepared.")
                success = false
            }
            sqlite3_finalize(insertStatement)
        }
        return success
    }
    
    // Quiz DAL (getAllQuizzes, getByName, createQuiz)
    static func getAllQuizzes() -> [Quiz]? {
        guard let quizzesResultSet = query(modelType: Quiz.quiz, queryString: "SELECT * FROM Quiz;") else {
            return nil
        }
        return Quiz.convert(quizzesResultSet: quizzesResultSet)
    }
    
    static func getByName(name: String) -> [Quiz]? {
        guard let quizzesResultSet = query(modelType: Quiz.quiz, queryString: "SELECT * FROM Quiz WHERE name = '\(name)';") else {
            return nil
        }
        return Quiz.convert(quizzesResultSet: quizzesResultSet)
    }
    
    static func createQuiz(name: String, imageName: String) -> Bool? {
        guard let db = SQLiteDatabase.getDatabase() else {
            return nil
        }
        var success = true
        let insertStatementString = "INSERT INTO Quiz ( name, imageName ) VALUES ( ?, ? )"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, NSString(string: name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: imageName).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\n INSERT statement is not prepared.")
                success = false
            }
            sqlite3_finalize(insertStatement)
        }
        return success
    }
    
    // QuizAttempt DAL (getAllQuizAttempts, getQuizAttemptsByUser, getQuizAttemptsByUserAndQuiz, createQuizAttempt)
    static func getAllQuizAttempts() -> [QuizAttempt]? {
        guard let quizAttemptsResultSet = query(modelType: QuizAttempt.quizAttempt, queryString: "SELECT * FROM QuizAttempt;") else {
            return nil
        }
        return QuizAttempt.convert(quizAttemptsResultSet: quizAttemptsResultSet)
    }
    
    static func getQuizAttemptsByUser(userID: Int) -> [QuizAttempt]? {
        guard let quizAttemptsResultSet = query(modelType: QuizAttempt.quizAttempt, queryString: "SELECT * FROM QuizAttempt WHERE userID = '\(userID)';") else {
            return nil
        }
        return QuizAttempt.convert(quizAttemptsResultSet: quizAttemptsResultSet)
    }
    
    static func getQuizAttemptsByUserAndQuiz(userID: Int, quizID: Int) -> [QuizAttempt]? {
        guard let quizAttemptsResultSet = query(modelType: QuizAttempt.quizAttempt, queryString: "SELECT * FROM QuizAttempt WHERE userID = '\(userID)' AND quizID = '\(quizID)';") else {
            return nil
        }
        return QuizAttempt.convert(quizAttemptsResultSet: quizAttemptsResultSet)
    }
    
    static func createQuizAttempt(userID: Int, quizID: Int, score: Float) -> Bool? {
        guard let db = SQLiteDatabase.getDatabase() else {
            return nil
        }
        var success = true
        
        let insertStatementString = "INSERT INTO QuizAttempt ( userID, quizID, score ) VALUES ( ?, ?, ? )"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(userID))
            sqlite3_bind_int(insertStatement, 2, Int32(quizID))
            sqlite3_bind_double(insertStatement, 3, Double(score))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\n INSERT statement is not prepared.")
                success = false
            }
            sqlite3_finalize(insertStatement)
        }
        return success
    }
    
    // QuestionAnswer DAL (getAllQuestionAnswers, getQuestionAnswersByQuiz, createQuestionAnswer)
    static func getAllQuestionAnswers() -> [QuestionAnswer]? {
        guard let questionAnswersResultSet = query(modelType: QuestionAnswer.questionAnswer, queryString: "SELECT * FROM QuestionAnswer;") else {
            return nil
        }
        return QuestionAnswer.convert(questionAnswersResultSet: questionAnswersResultSet)
    }
    
    static func getQuestionAnswersByQuiz(quizID: Int) -> [QuestionAnswer]? {
        guard let questionAnswersResultSet = query(modelType: QuestionAnswer.questionAnswer, queryString: "SELECT * FROM QuestionAnswer WHERE quizID = '\(quizID)';") else {
            return nil
        }
        return QuestionAnswer.convert(questionAnswersResultSet: questionAnswersResultSet)
    }
    
    static func createQuestionAnswer(quizID: Int, question: String, answer: String, wrong_options: String) -> Bool? {
        guard let db = SQLiteDatabase.getDatabase() else {
            return nil
        }
        var success = true
        
        let insertStatementString = "INSERT INTO QuestionAnswer ( quizID, question, answer, wrong_options ) VALUES ( ?, ?, ?, ? )"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(quizID))
            sqlite3_bind_text(insertStatement, 2, NSString(string: question).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: answer).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, NSString(string: wrong_options).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\n INSERT statement is not prepared.")
                success = false
            }
            sqlite3_finalize(insertStatement)
        }
        return success
    }
}
