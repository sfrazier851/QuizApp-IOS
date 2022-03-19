//
//  DBInit.swift
//  QuizApp-IOS
//
//  Created by admin on 3/15/22.
//

import Foundation
import SQLite3
var c = DBInit()

class DBInit{
    static var db : OpaquePointer?
     init(){
         print("DBINIT")
         openDb()
    }
    func openDb(){
        print("DBOPEN")

        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
          let url = NSURL(fileURLWithPath: path)
          if let pathComponent = url.appendingPathComponent("QuizIos.sqlite") {
              let filePath = pathComponent.path
              let fileManager = FileManager.default
              if fileManager.fileExists(atPath: filePath) {
                  print("FILE AVAILABLE")
                  if sqlite3_open(filePath, &DBInit.db) != SQLITE_OK{
                              print("Can't Open Database")
                          }
              } else {
                  print("FILE NOT AVAILABLE")
                  createTable()
                  fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
              }
              if sqlite3_open(filePath, &DBInit.db) != SQLITE_OK{
                          print("Can't Open Database")
                      }
          } else {
              print("FILE PATH NOT AVAILABLE")
          }

    }
    func initUser(){
        let u1=UserModels(UserName: "guest", Password: "2", DOB: "June 2, 1994", admin: false, subriction: "trial", Status: "clear", First: "2", Last: "2", email: ["2@gmail.com"])
        let u2=UserModels(UserName: "admin", Password: "2", DOB: "June 2, 1994", admin: true, subriction: "paid", Status: "clear", First: "admin", Last: "admin", email: ["admin@gmail.com"])
        DBCRUD.initDBCRUD.createUserWithUserModal(us: u1)
        DBCRUD.initDBCRUD.createUserWithUserModal(us: u2)
    }
    func createTable(){
        print("DBCREATETABLE")
        var stmt : String
        
        //Technology table
        stmt="CREATE TABLE IF NOT EXISTS `Technology` (`Title` TEXT NOT NULL, PRIMARY KEY (`Title`))"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Technology table", err)
            return
        }
        //Emails
        stmt="CREATE TABLE IF NOT EXISTS `Emails` (`Emails` TEXT NOT NULL, `User_ID` INT NOT NULL, PRIMARY KEY (`Emails`, `User_ID`), CONSTRAINT `fk_Emails_User1` FOREIGN KEY (`User_ID`) REFERENCES User (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION);CREATE INDEX `fk_Emails_User1_idx` ON `Emails` (`User_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Emails table", err)
        }
        //Question table
        stmt="CREATE TABLE IF NOT EXISTS `Questions` (`Question` TEXT NULL, `Awnser` TEXT NOT NULL,`Quiz_ID` INT NOT NULL, `ID` INT  AUTO_INCREMENT NOT NULL, PRIMARY KEY (`ID`), CONSTRAINT `fk_Questions_Quiz1` FOREIGN KEY (`Quiz_ID`) REFERENCES `Quiz` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Questions_Quiz1_idx` ON `Questions` (`Quiz_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Question table", err)
        }
        	
        //Choices
        stmt="CREATE TABLE IF NOT EXISTS `choices` (`choice` TEXT NOT NULL, `Questions_ID` INT NOT NULL, PRIMARY KEY (`choice`), CONSTRAINT `fk_choices_Questions1` FOREIGN KEY (`Questions_ID`) REFERENCES `Questions` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_choices_Questions1_idx` ON `choices` (`Questions_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Choices table", err)
        }
        //Quiz has dual keys
        stmt="CREATE TABLE IF NOT EXISTS `Quiz` ( `Title` TEXT NULL, `ID` INTEGER Primary KEY AUTOINCREMENT NOT NULL, `Technology_Title` TEXT NOT NULL, CONSTRAINT `fk_Quiz_Technology1` FOREIGN KEY (`Technology_Title`) REFERENCES `Technology` (`Title`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Quiz_Technology1_idx` ON `Quiz` (`Technology_Title` ASC);"
        
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Quiz table", err)
        }
        

        //Prizes has dual keys
        	stmt="CREATE TABLE IF NOT EXISTS `Prizes` (`idPrizes` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `GivenDate` DATE NULL, `StartDate` DATE NULL, `EndDate` DATE NULL, `active` TINYINT NULL, `Type` TEXT NULL, `User_ID` INT NOT NULL, CONSTRAINT `fk_Prizes_User1` FOREIGN KEY (`User_ID`) REFERENCES `User` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Prizes_User1_idx` ON `Prizes` (`User_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Prizes table", err)
        }
        
        //Score table
        stmt="CREATE TABLE IF NOT EXISTS `ScoreBoard` (`Score` INT NOT NULL, `Quiz_ID` INT NOT NULL, `User_ID` INT NOT NULL, `Technology_Title` TEXT NOT NULL, PRIMARY KEY (`User_ID`),   CONSTRAINT `fk_ScoreBoard_Quiz1` FOREIGN KEY (`Quiz_ID`) REFERENCES `Quiz` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION, CONSTRAINT `fk_ScoreBoard_User1` FOREIGN KEY (`User_ID`)  REFERENCES `User` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION, CONSTRAINT `fk_ScoreBoard_Technology1` FOREIGN KEY (`Technology_Title`) REFERENCES `Technology` (`Title`) ON DELETE NO ACTION ON UPDATE NO ACTION);  CREATE INDEX `fk_ScoreBoard_Quiz1_idx` ON `ScoreBoard` (`Quiz_ID` ASC);  CREATE INDEX `fk_ScoreBoard_Technology1_idx` ON `ScoreBoard` (`Technology_Title` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Score table", err)
        }
        //User table
        stmt="CREATE TABLE `User` (`ID` INTEGER Primary KEY  AUTOINCREMENT NOT NULL, `UserName` TEXT NULL, `Password` TEXT NOT NULL, `Dob` DATE NULL, `admin` TINYINT NULL, `subcription` TEXT NULL, `Status` INT NULL, `First` TEXT NULL, `Last` TEXT NULL)"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating User table", err)
        }
        
        //Reviews has dual keys
        stmt="CREATE TABLE IF NOT EXISTS `Reviews` (`idReviews` INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL, `rate` INT NULL, `comments` TEXT NULL, `User_ID` INT NOT NULL, CONSTRAINT `fk_Reviews_User1` FOREIGN KEY (`User_ID`) REFERENCES `User` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Reviews_User1_idx` ON `Reviews` (`User_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Reviews table", err)
        }
        initUser()
    }
    
}
	
