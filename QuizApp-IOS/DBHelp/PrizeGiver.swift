//
//  PrizeGiver.swift
//  QuizApp-IOS
//
//  Created by admin on 3/28/22.
//

import Foundation
class prizeGiver{
    static let initPrizeGiver = prizeGiver()
    var lastUpdate:Date
    var StartedDate:Date
    private init(){
        self.lastUpdate=Utilities.isToDate(day: DBCRUD.initDBCRUD.getPrizeFromPrizeID(id: 2).GivenDate)
        self.StartedDate=Utilities.isToDate(day: DBCRUD.initDBCRUD.getPrizeFromPrizeID(id: 1).GivenDate)
        
    }
    func Update(){
        if lastUpdate == Date() {return}//if we try to update on the same day we started return
   
        while lastUpdate < Date(){
            lastUpdate=Calendar.current.date(byAdding: .day, value: 1, to: lastUpdate)!
            for Technology in ["IOS","Andriod","Java"]{
            var count = 0
                var Rank:[ScoreBoardModels]=DBCRUD.initDBCRUD.getTacRankDay(Technology_Title: Technology, Date:Utilities.formatDate(date: lastUpdate), Limit: 10)
                
                while !Rank.isEmpty{
                    DBCRUD.initDBCRUD.createPrize(prize: Prize(GivenDate: Utilities.DatetoString(day: lastUpdate), User_ID: Rank[0].User_ID, PrizeType: 0, value: count))
                    Rank.removeFirst()
                    count+=1
                    if count == 3 {
                        break
                    }
                }
                
                
            }
        }
        var toUpdate:Prize = DBCRUD.initDBCRUD.getPrizeFromPrizeID(id: 2)
        toUpdate.GivenDate=Utilities.DatetoString(day: lastUpdate)
        toUpdate.save()
    }
}
