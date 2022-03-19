//
//  UserModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation

class UserModels{
    enum SubcriptionType:String, CaseIterable{
         case prize = "awarded"
        case trial = "trail"
        case paid = "paid"
    
    }
    var Email:[String]
    var Password:String
    var Subscript:String
    var status:String
    
    //optional fields
    var ID:Int?//its given
    var UserName:String?//User Choice
    var First:String?
    var Last:String?
    var Dob:String?
    var admin:Bool?//Not Always needed in all cases
    init(){
        Email=[String]()
        Password=""
        Subscript=SubcriptionType.trial.rawValue
        status="unblocked"
        
    }
    init(ID:Int, UserName:String, Password:String, DOB:String, admin:Bool, subriction:String, Status:String, First:String, Last:String, email:[String]){
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
    init(Email:String, Password:String){
        self.Email=[String]()
        self.Password=Password
        Subscript=SubcriptionType.trial.rawValue
        status="unblocked"
    }
    		
}
