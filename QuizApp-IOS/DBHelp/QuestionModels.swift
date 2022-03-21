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
    var Quiz_ID:Int = 0
    var ID:Int = 0
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
    init(Question:String, Awnser:String){
        self.Question=Question
        self.Awnser=Awnser
     
    }
    init(Question:String, Awnser:String, choice:[String]){
        self.Question=Question
        self.Awnser=Awnser
        self.choices=choice
    }
    init(Question:String, Awnser:String, Quiz_ID:Int, choice:[String]){
        self.Question=Question
        self.Awnser=Awnser
        self.Quiz_ID=Quiz_ID
        self.choices=choice
    }
    init(Question:String, Awnser:String, Quiz_ID:Int, ID:Int, choice:[String]){
        self.Question=Question
        self.Awnser=Awnser
        self.Quiz_ID=Quiz_ID
        self.ID=ID
        self.choices=choice
    }
}
