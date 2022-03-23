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
         initquiz()
    }
    func openDb(){
        print("DBOPEN")
        
        let flagExist:Bool = FileManager.default.fileExists(atPath: (NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String).appendingPathComponent("QuizIos.sqlite"))!.path)

       
        
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("QuizIos.sqlite")
  
        print("db path is", fileP)
        
        if sqlite3_open(fileP.path, &DBInit.db) != SQLITE_OK{
            print("Can't Open Database")
        }
        if !flagExist{
            print("File didn't Exist")
            createTable()} else{
                print("File Exist")
            }
    }
    func initquiz(){

        print("Testing Quiz")
        var qArr = [
                ["It is a subsystem in Java Virtual Machine dedicated to loading class files when a program is executed.","classLoader","bootstrapLoader","applet","java kit","classLoader"],
                ["It is called when an instance of the object is created, and memory is allocated for the object.","Method","Constructor","Class","Object","Constructor"],
                ["The founder and lead designer behind the Java Programming Language.","James Gosling","Alan Turing","Larry Ellison","Dennis Ritchie","James Gosling"],
                ["It is a technique in Java of having more than one constructor with different parameter lists.","Constructor Overloading","Constructor Overriding","Method Overloading","Method Overriding","Constructor Overloading"],
                ["It is a mechanism in which one object acquires all the properties and behaviors of a parent object.","Inheritance","Encapsulation","Polymorphism","Abstraction","Inheritance"],
                ["It is the ability of an object to take on many forms.", "Inheritance","Encapsulation","Polymorphism","Abstraction","Polymorphism"],
                ["It is a process of wrapping code and data together into a single unit.","Inheritance","Encapsulation","Polymorphism","Abstraction","Encapsulation"],
                ["It is a process of hiding the implementation details and showing only functionality to the user.","Inheritance","Encapsulation","Polymorphism","Abstraction","Abstraction"],
                ["It is a template or blueprint from which objects are created.","Class","Constructor","Struct","Enum","Class"],
                ["It is a class which inherits the other class. It is also called a derived class, extended class, or child class.","Sub Class","Super Class","Function","Protocol","Sub Class"],
                ["It is the class from where a subclass inherits the features. It is also called a base class or a parent class.", "Method","Abstraction","Object","Super Class","Super Class"],
                ["It indicates that you are making a new class that derives from an existing class.", "extends", "let","birthed","reached","extends"],
                ["All are types of Inheritance except:","Single Inheritance","Multi-Level Inheritance","Hierarchical Inheritance","Heirarchical Inheritance","Heirarchical Inheritance"],
                ["All are advantages of Encapsulation except:","Not Accessible","Control Over Data","Data Hiding","Easy To Test","Not Accessible"],
                ["It specifies accessibility (scope) of a data member, method, constructor or class.","Access Modifiers","Struct","Constants","Class","Access Modifiers"]
            ]
        //saving
        print("saving")
              var questions=[QuestionModels]()
              for i in qArr{
                  questions.append(QuestionModels(Question: i[0], Awnser: i[4], choice: [i[1],i[2],i[3]]))
              }
              let t1:QuizModels=QuizModels(Title: "quiz title", Technology_Title: "Java", Questions: questions)
              t1.save()
              print("loading")
              //loading
              let t2:QuizModels=DBCRUD.initDBCRUD.getQuiz(id: t1.ID!)
              
              t2.loadQuestion()
              for question in t2.Questions!{
                  print(question.ID,question.Awnser, question.choices)
              }

    }
    func initUser(){
        let u1=UserModels(UserName: "guest", Password: "123Password!", DOB: "June 2, 1994", admin: false, subriction: "trial", Status: "clear", First: "2", Last: "2", email: ["2@gmail.com"])
        let u2=UserModels(UserName: "admin", Password: "123Password!", DOB: "June 2, 1994", admin: true, subriction: "paid", Status: "clear", First: "admin", Last: "admin", email: ["admin@gmail.com"])
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
        stmt="CREATE TABLE IF NOT EXISTS `Questions` (`Question` TEXT NULL, `Awnser` TEXT NOT NULL,`Quiz_ID` INT NOT NULL, `ID` INTEGER Primary KEY AUTOINCREMENT NOT NULL, CONSTRAINT `fk_Questions_Quiz1` FOREIGN KEY (`Quiz_ID`) REFERENCES `Quiz` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Questions_Quiz1_idx` ON `Questions` (`Quiz_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Question table", err)
        }
        	
        //Choices
        stmt="CREATE TABLE IF NOT EXISTS `choices` (`choice` TEXT NOT NULL,  `Questions_ID` INT NOT NULL,  CONSTRAINT `fk_choices_Questions1` FOREIGN KEY (`Questions_ID`) REFERENCES `Questions` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_choices_Questions1_idx` ON `choices` (`Questions_ID` ASC);"
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
	
