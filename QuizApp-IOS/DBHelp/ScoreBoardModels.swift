//
//  ScoreBoardModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/16/22.
//

import Foundation
    	
class ScoreBoardModels{
    var Score : Int
    var Quiz_ID : Int
    var User_ID : Int
    var TakenDate :String
    var Technology_Title:String
    init(){  self.Score=0
        self.Quiz_ID=0
        self.User_ID=0
        self.TakenDate = Utilities.formatDate(date: Date())
        self.Technology_Title="Technology_Title"}
    init(Score:Int, Quiz_ID:Int, User_ID:Int, Technology_Title:String){
        self.Score=Score
        self.Quiz_ID=Quiz_ID
        self.User_ID=User_ID
        self.Technology_Title=Technology_Title
        self.TakenDate = Utilities.formatDate(date: Date())
    }
    init(Score:Int, Quiz_ID:Int, User_ID:Int, Technology_Title:String, TakenDate:String){
        self.TakenDate = TakenDate
        self.Score=Score
        self.Quiz_ID=Quiz_ID
        self.User_ID=User_ID
        self.Technology_Title=Technology_Title
    }
   
    func delete(){
        DBCRUD.initDBCRUD.deleteAUserScore(User_ID: self.User_ID, Quiz_ID: self.Quiz_ID)
    }
}
