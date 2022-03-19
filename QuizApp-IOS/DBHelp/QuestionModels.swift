//
//  QuestionModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/18/22.
//

import Foundation

class QuestionModels{
    var Question:String
    var Awnser:String
    var Quiz_ID:Int
    var ID:Int
    var choices:[String]?
    init(){
        self.Question=""
        self.Awnser=""
        self.Quiz_ID=0
        self.ID=0
    }
    init(Question:String, Awnser:String, Quiz_ID:Int, ID:Int){
        self.Question=Question
        self.Awnser=Awnser
        self.Quiz_ID=Quiz_ID
        self.ID=ID
    }
}
