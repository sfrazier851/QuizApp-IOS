//
//  QuizModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation
class QuizModels{
    var ID:Int?
    var Questions:[QuestionModels]?
    var Title:String
    var Technology_Title:String
    init(){Title=""
        Technology_Title=""
    }
    init(Title:String, Technology_Title:String){
        self.Title=Title
        self.Technology_Title=Technology_Title
    }
    init( Title:String, ID:Int, Technology_Title:String  ){
        self.Title=Title
        self.Technology_Title=Technology_Title
        self.ID=ID
        loadQuestion()
    }
    init( Title:String, Technology_Title:String, Questions:[QuestionModels]  ){
        self.Questions=Questions
        self.Title=Title
        self.Technology_Title=Technology_Title
     
    }
    init( Title:String, ID:Int, Technology_Title:String, Questions:[QuestionModels]  ){
        self.Questions=Questions
        self.Title=Title
        self.Technology_Title=Technology_Title
        self.ID=ID
    }
    func delete(){
       if self.ID != nil{
            DBCRUD.initDBCRUD.deleteAQuiz(NE: self.ID!)
        }else{
            print("you can't delete without ID")
        }
    }
    func loadQuestion(){
        Questions=DBCRUD.initDBCRUD.getQuestionsForQuiz(id: self.ID!)
        loadQuestionsChoices()
    }
    func loadQuestionsChoices(){
        if (self.Questions != nil){
            for Question in self.Questions!{
                Question.loadChoices()
            }
        } else{
            print("there are no choices")
        }
    }
    func isIN()->Bool{
        let u = DBCRUD.initDBCRUD.getQuizByTitle(title: self.Title, Technology_Title: self.Technology_Title)
        if u?.ID != nil{
            self.ID = u?.ID
            loadQuestion()
            return true
        }
        return false
    }
    func save(){
         if isIN(){
            DBCRUD.initDBCRUD.updateQuiz(r: self)
        }else{
            self.ID = DBCRUD.initDBCRUD.createQuiz(r: self)
        }
        if Questions != nil {
            for question in Questions!{
                question.Quiz_ID=self.ID!
                question.save()
            }
        }
    }
}
