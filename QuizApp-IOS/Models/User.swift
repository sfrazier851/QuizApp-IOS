//
//  User.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/20/22.
//

import Foundation

struct User {
    var id: Int = 0
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var is_loggedin: Bool = false
    var is_blocked: Bool = false
    var is_subscribed: Bool = false
    var is_admin: Bool = false
    var app_feedback: String = ""
    
    static let user = User()
    
    // Convert user result set to Array of User
    static func convert(usersResultSet: [[String]]) -> [User]? {
        var users = [User]()
        for user_row in usersResultSet {
            let columns = user_row
            
            var user = User()
            user.id = Int(columns[0])!
            user.username = columns[1]
            user.email = columns[2]
            user.password = columns[3]
            user.is_loggedin = Int(columns[4])! == 0 ? false : true
            user.is_blocked = Int(columns[5])! == 0 ? false : true
            user.is_subscribed = Int(columns[6])! == 0 ? false : true
            user.is_admin = Int(columns[7])! == 0 ? false : true
            user.app_feedback = columns[8]
            
            users.append(user)
        }
        return users
    }
    
    static func getAll() -> [User]? {
        return SQLiteDAL.getAllUsers()
    }
    
    static func getByEmail(email: String) -> [User]? {
        return SQLiteDAL.getUsersByEmail(email: email)
    }
    
    static func getByUsername(username: String) -> [User]? {
        return SQLiteDAL.getUsersByUsername(username: username)
    }
    
    static func create(username: String, email: String, password: String) -> Bool? {
        return SQLiteDAL.createUser(username: username, email: email, password: password)
    }
}
