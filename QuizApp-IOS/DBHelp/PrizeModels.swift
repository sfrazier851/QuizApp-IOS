//
//  PrizeModels.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation
import SQLite3
class Prize{
    enum PrizeType:Int, CaseIterable{
         case given = 2
        case paid = 1
        case awarded = 0
    
    }
    var idPrize:Int?
    var GivenDate:String
    var StartDate:String?
    var EndaDate:String?
    var PrizeType:Int?
    var User_ID:Int
    var active:Int?
    var value:Int?
    init(){
        GivenDate=""
        User_ID=0
    }
    
    init(idPrize:Int,GivenDate:String, User_ID:Int, PrizeType:Int){
        self.idPrize=idPrize
        self.GivenDate=GivenDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        
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
    
    init(GivenDate:String, startDate:String,EndaDate:String,PrizeType:Int,User_ID:Int, active:Int, value:Int){

        self.GivenDate=GivenDate
        self.StartDate=startDate
        self.EndaDate=EndaDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        self.active=active
        self.value=value
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
    
    init(idPrize:Int,GivenDate:String, startDate:String,EndaDate:String,PrizeType:Int,User_ID:Int, active:Int, value:Int){

        self.idPrize=idPrize
        self.GivenDate=GivenDate
        self.StartDate=startDate
        self.EndaDate=EndaDate
        self.PrizeType=PrizeType
        self.User_ID=User_ID
        self.active=active
        self.value=value
    }
    func save(){
        if idPrize != nil{
            DBCRUD.initDBCRUD.updatePrize(prize: self)}
        else {
            DBCRUD.initDBCRUD.createPrize(prize: self)
        }
    }
    func isIN()->Bool{
        if self.idPrize != nil {
            	return true
        }
        return false
    }
    func activate(){
        if value == 0{
         //no value was given
            return
        }
        if active == 1{
            //already active
            return
        }
        var dateComponenet = DateComponents()
        dateComponenet.day=value
        self.active=1
        let LatestPrize = DBCRUD.initDBCRUD.getLatestActivePrize(UserID: (LoginPort.user?.ID)!)[0]
        if LatestPrize.EndaDate == ""{
            self.StartDate=Utilities.DatetoString(day: Date())
           let endDate = Calendar.current.date(byAdding: dateComponenet, to: Date())
            self.EndaDate = Utilities.DatetoString(day: endDate!)
        }else{
            let lastday = Utilities.isToDate(day: LatestPrize.EndaDate!)
            var plusOneday = DateComponents()
            plusOneday.day=1
            let startday = Calendar.current.date(byAdding: plusOneday, to: lastday)!
            self.StartDate=Utilities.DatetoString(day:startday)
            self.EndaDate = Utilities.DatetoString(day:  Calendar.current.date(byAdding: dateComponenet, to: startday)!)
        }
    }
    func delete(){
        DBCRUD.initDBCRUD.deleteAPrize(NE: self.idPrize!)
    }
}
