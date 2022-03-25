//
//  Login.swift
//  QuizApp-IOS
//
//  Created by admin on 3/16/22.
//

import Foundation
import SQLite3

class LoginPort {
    
    static let initLogin = LoginPort()
    private init(){}
    static var user:UserModels?

    func login(S:String, PW:String)->Bool{
        
        if DBCRUD.initDBCRUD.UserIDToPassword(id: DBCRUD.initDBCRUD.EmailToUserID(NE: S)) == PW {
           
            //print("Login Successful")
            LoginPort.user = DBCRUD.initDBCRUD.UserIDToUser(id:DBCRUD.initDBCRUD.EmailToUserID(NE: S) )
            K.user_id = DBCRUD.initDBCRUD.EmailToUserID(NE: S)
            //print("UID: \(K.user_id)")
            //print("user is", LoginPort.user?.UserName)
            return true
        
        }

        //print("login fail")
        return false
    
    }
    
    func logout() {
     
        LoginPort.user=nil
        UserSessionManager.endSession()
    
    }
    
}
