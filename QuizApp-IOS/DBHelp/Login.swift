//
//  Login.swift
//  QuizApp-IOS
//
//  Created by admin on 3/16/22.
//

import Foundation
import SQLite3

class LoginPort{
    static var user:UserModels?
func login(S:String, PW:String){
    if DBCRUD.initDBCRUD.UserIDToPassword(id: DBCRUD.initDBCRUD.EmailToUserID(NE: S)) == PW{
        LoginPort.user = DBCRUD.initDBCRUD.UserIDToUser(id:DBCRUD.initDBCRUD.EmailToUserID(NE: S) )
    }
    func logout(){
        LoginPort.user=nil
    }
    
}
}
