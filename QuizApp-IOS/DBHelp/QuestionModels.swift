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
    var ID:Int?
    var choices:[String]?
    init(){
        self.Question=""
        self.Awnser=""
        self.Quiz_ID = -1
        
    }
    init(Question:String, Awnser:String, Quiz_ID:Int){
        self.Question=Question
        self.Awnser=Awnser
        self.Quiz_ID=Quiz_ID
        
    }
    init(Question:String, Awnser:String, Quiz_ID:Int, ID:Int){
        self.Question=Question
        self.Awnser=Awnser
        self.Quiz_ID=Quiz_ID
        self.ID=ID
        
    }
    init(Question:String, Awnser:String, choice:[String]){
        self.Question=Question
        self.Awnser=Awnser
        self.choices=choice
        Quiz_ID = -1
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
    func loadChoices(){
        if self.ID != nil{
            self.choices=DBCRUD.initDBCRUD.getChoiceFromQuestionID(id: self.ID!)
            if self.choices!.isEmpty || self.choices==nil{
                print("No choice was given")
            }
        }
        else{
            print("Can't Get choices no ID")
        }
    }
    func errorcheck()->Bool{
        //error handling
        if(Quiz_ID == -1){
         print("A quiz wasn't given to question")
            return true
        }
        if(choices == nil){
            print("There are no choices")
            return true
        }
        return false
    }
    func save(){
        if errorcheck(){ return;}
        
        if ID == nil{
            let id = DBCRUD.initDBCRUD.createQuestion(r: self)
            if id != -1{
                for choice in choices!{
                DBCRUD.initDBCRUD.createChoice(Choice: choice, ID: id)}
        }
            else{
                print("question couldn't be added")
            }
       
        } else{
            DBCRUD.initDBCRUD.updateQuestion(r: self)
            DBCRUD.initDBCRUD.deleteQuestionsChoice(ID: self.ID!)
            for i in self.choices!{
                DBCRUD.initDBCRUD.createChoice(Choice: i, ID: self.ID!)
            }
            
    }
    
}
}
