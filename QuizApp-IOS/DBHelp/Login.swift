//
//  Login.swift
//  QuizApp-IOS
//
//  Created by admin on 3/16/22.
//

import Foundation
import SQLite3

class LoginPort{
    static let initLogin = LoginPort()
    private init(){}
    static var user:UserModels?
func login(S:String, PW:String)->Bool{
    print("trying to login",S," With",PW)
    if DBCRUD.initDBCRUD.UserIDToPassword(id: DBCRUD.initDBCRUD.EmailToUserID(NE: S)) == PW{
        print("Login Successful")
        LoginPort.user = DBCRUD.initDBCRUD.UserIDToUser(id:DBCRUD.initDBCRUD.EmailToUserID(NE: S) )
        print("user is", LoginPort.user?.UserName)
        return true
    }
    print("login fail")
    return false
    
    
}
    
    func logout(){
        LoginPort.user=nil
    }
}
