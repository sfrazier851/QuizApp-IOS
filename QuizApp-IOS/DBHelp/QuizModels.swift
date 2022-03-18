//
//  QuizModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation
class QuizModels{
    var ID:Int?
    var Questions:[Question]?
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
    }
}
