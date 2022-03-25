//
//  ReviewModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/17/22.
//

import Foundation
class ReviewModels{
    var rate:Int
    var comments:String
    var idReviews:Int?
    var User_ID:Int?
    init(){
        rate=0
        comments=""
    }
    init(rate:Int, comments:String, idReviews:Int, User_ID:Int){
        self.rate=rate
        self.comments=comments
        self.idReviews=idReviews
        self.User_ID=User_ID
    }
    func save(){
        DBCRUD.initDBCRUD.createReview(r: self)
    }
    func delete(){
        DBCRUD.initDBCRUD.deleteAReview(NE: self.idReviews!)
    }
}
