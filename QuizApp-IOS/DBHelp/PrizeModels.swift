//
//  PrizeModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation
class Prize{
    var idPrize:Int?
    var GivenDate:String
    var StartDate:String?
    var EndaDate:String?
    var PrizeType:Int?
    var User_ID:Int
    var active:Int?
    init(){
        GivenDate=""
        User_ID=0
    }
    init(GivenDate:String, User_ID:Int, PrizeType:Int){
        self.GivenDate=GivenDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        
    }
    init(GivenDate:String, startDate:String,EndaDate:String,PrizeType:Int,User_ID:Int, active:Int){
        self.GivenDate=GivenDate
        self.StartDate=startDate
        self.EndaDate=EndaDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        self.active=active
    }
    init(idPrize:Int,GivenDate:String, startDate:String,EndaDate:String,PrizeType:Int,User_ID:Int, active:Int){
        self.idPrize=idPrize
        self.GivenDate=GivenDate
        self.StartDate=startDate
        self.EndaDate=EndaDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        self.active=active
    }
    func save(){
        DBCRUD.initDBCRUD.updatePrize(prize: self)
    }
    func isIN()->Bool{
        if self.idPrize != nil {
            DBCRUD.initDBCRUD.getPrizeFromPrizeID(id: self.idPrize!)
            	return true
        }
        return false
    }
    func delete(){
        DBCRUD.initDBCRUD.deleteAPrize(NE: self.idPrize!)
    }
}
