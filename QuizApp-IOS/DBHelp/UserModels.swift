//
//  UserModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation

class UserModels{
    
    enum SubcriptionType:Int, CaseIterable{
         case prize = 2
        case trial = 1
        case paid = 0
    
    }
    var Email:[String]
    var Password:String
    var Subscript:Int
    var status:String
    
    //optional fields
    var ID:Int?//its given
    var UserName:String? = "User"//User Choice
    var First:String? = "First"
    var Last:String? = "Last"
    var Dob:String? = "Some Day"
    var admin:Bool? = false//Not Always needed in all cases
    init(){
        Email=[String]()
        Password=""
        Subscript=SubcriptionType.trial.rawValue
        status=""
        
    }
    init( UserName:String, Password:String, DOB:String, admin:Bool, subriction:Int, Status:String, First:String, Last:String, email:[String]){
        self.UserName = UserName
        self.Password = Password
        self.Dob=DOB
        self.admin=admin
        self.Subscript=subriction
        self.status = Status
        self.First = First
        self.Last = Last
        self.Email = email
    }
    init(ID:Int, UserName:String, Password:String, DOB:String, admin:Bool, subriction:Int, Status:String, First:String, Last:String, email:[String]){
        self.ID=ID
        self.UserName = UserName
        self.Password = Password
        self.Dob=DOB
        self.admin=admin
        self.Subscript=subriction
        self.status = Status
        self.First = First
        self.Last = Last
        self.Email = email
    }
    init(Email:String, Password:String, UserName:String){
        self.Email=[Email]
        self.Password=Password
        self.UserName=UserName
        Subscript=SubcriptionType.trial.rawValue
        status=""
    }
    func save(){
        if ID != nil{
            DBCRUD.initDBCRUD.updateUser(us: self)
        }
    }
    func delete(){
        for email in Email{
            DBCRUD.initDBCRUD.deleteAEmail(NE: email)
        }
        DBCRUD.initDBCRUD.DeleteUser(ID: self.ID!)
    }
    func toggleBlock(){
        if status==""{
            status="BLOCKED"
        }else{
            status=""
        }
    }
}
