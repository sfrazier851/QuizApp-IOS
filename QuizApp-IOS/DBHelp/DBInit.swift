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
                  questions.append(QuestionModels(Question: i[0], Awnser: i[5], choice: [i[1],i[2],i[3],i[4]]))              }
              let t1:QuizModels=QuizModels(Title: "quiz title1", Technology_Title: "Java", Questions: questions)
              t1.save()
        qArr = [
                ["What does IOS mean?","Internet Operation System","iPhone Operation System","Interval Operation System","iPhone Overriding System","iPhone Operation System"],
                ["It manages the appearance of the table.","UITableView","UIViewController","UICollectionView","UIImageView","UITableView"],
                ["It is the topmost layer in the iOS Architecture.","Core Services","Media Services","Cocoa Touch","Core OS","Cocoa Touch"],
                ["It is a connection or reference to the object created in the Interface Builder.","IBOutlet","IBAction","IBVariables","IBObject","IBOutlet"],
                ["A file that contains a key-value pair configuration of your application.","info.plist","dictionary","keychain","bundle identifier","info.plist"],
                ["It is a technology that allows transmission of data, voice and video through a computer or any portable device.","Mobile Programming", "Mobile Data","Mobile Computing","Mobile Phone","Mobile Computing"],
                ["For unwrapping value inside an Optional, what should be used?","!","!@","@","None Of Them","!"],
                ["What is the name of the deinitializer in the class declaration?","dealloc","release","deinit","finalize","deinit"],
                ["Which keyword do you use to define a protocol?", "protocol","@protocol","@interface","Protocol", "protocol"],
                ["Which keyword in the context of a Switch statement is required to force the execution of a subsequent case?","fallthrough","break","continue","throw","fallthrough"]
            ]
        questions=[QuestionModels]()
        for i in qArr{
            questions.append(QuestionModels(Question: i[0], Awnser: i[5], choice: [i[1],i[2],i[3],i[4]]))}
        let t2:QuizModels=QuizModels(Title: "quiz title2", Technology_Title: "IOS", Questions: questions)
        t2.save()
        qArr = [
                ["Android Architecture is made up of the following components except:","Linux Kernel","Android Frameworks","Libraries","Cocoa Touch","Cocoa Touch"],
                ["This is where you can find all the classes and methods that developers would need in order to write applications on the Android environment.","Libraries","Android Frameworks","Android Applications","Linux Kernel","Android Frameworks"],
                ["This tool provides developers with the ability to deal with zip-compatible archives, which includes creating, extracting as well as viewing its contents.","Android Asset Packaging Tool","Asset Android Packaging Tool","Apple Archive Package Tool","Andro Asset Packaging Tool","Android Asset Packaging Tool"],
                ["It is the first step towards the creation of a new Android project. It is made up of a shell script that will be used to create new file system structure necessary for writing codes within the Android IDE.","canvasCreator","projectCreator","activityCreator","libCreator","activityCreator"],
                ["Activities are what you refer to as the window to a user interface.","True","False","","","True"],
                ["All are essential states of an activity except:","Active","Paused","Destroyed","Inactive","Inactive"],
                ["It allows developers the power to execute remote shell commands. Its basic function is to allow and control communication towards and from the emulator port.", "Android Debug Bridge","Apple Debug Bridge","Android Debug Box","Android Debugger Bridge","Android Debug Bridge"],
                ["This is actually a dialog that appears to the user whenever an application have been unresponsive for a long period of time.","Application Not Responding","Agent Inactive Message","Window Blocker","State Not Active","Application Not Responding"],
                ["The 'and' elements must be present and can occur as much as it's needed.","True","False","","","False"],
                ["Andy Rubin originally founded Android under Android, Inc. in November 2003.","True","False","","","False"]
            ]
        questions=[QuestionModels]()
        for i in qArr{
            questions.append(QuestionModels(Question: i[0], Awnser: i[5], choice: [i[1],i[2],i[3],i[4]]))
        }

        let t3:QuizModels=QuizModels(Title: "quiz title3", Technology_Title: "Android", Questions: questions)
        t3.save()
        
             
              
              
initTech()
    }
    func initUser(){
        let u1=UserModels(UserName: "guest", Password: "123Password!", DOB: "June 2, 1994", admin: false, subriction: "trial", Status: "", First: "2", Last: "2", email: ["2@gmail.com"])
        let u2=UserModels(UserName: "admin", Password: "123Password!", DOB: "June 2, 1994", admin: true, subriction: "paid", Status: "", First: "admin", Last: "admin", email: ["admin@gmail.com"])
        let u3=UserModels(UserName: "BlockedUser", Password: "123Password!", DOB: "June 2, 1994", admin: false, subriction: "paid", Status: "BLOCKED", First: "This Guy", Last: "Who shall not be named", email: ["block@gmail.com"])
        if !DBCRUD.initDBCRUD.createUserWithUserModal(us: u1){
            print("error creating guest")
            return
        }
        if !DBCRUD.initDBCRUD.createUserWithUserModal(us: u2){
            print("error creating admin")
            return
        }
        if !DBCRUD.initDBCRUD.createUserWithUserModal(us: u3){
            print("error creating block")
            return
        }
        initquiz()
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
        

            stmt="CREATE TABLE IF NOT EXISTS `Prizes` (`idPrizes` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `GivenDate` DATE NULL, `StartDate` DATE NULL, `EndDate` DATE NULL, `active` TINYINT NULL, `Type` INT NULL, `User_ID` INT NOT NULL, CONSTRAINT `fk_Prizes_User1` FOREIGN KEY (`User_ID`) REFERENCES `User` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION); CREATE INDEX `fk_Prizes_User1_idx` ON `Prizes` (`User_ID` ASC);"
        if sqlite3_exec(DBInit.db, stmt, nil, nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(DBInit.db)!)
            print("there is error creating Prizes table", err)
        }
        
        //Score table
        stmt="CREATE TABLE IF NOT EXISTS `ScoreBoard` (`Score` INT NOT NULL, `Quiz_ID` INT NOT NULL, `User_ID` INT NOT NULL, `Technology_Title` TEXT NOT NULL, `TakenDate` TEXT NOT NULL, CONSTRAINT `fk_ScoreBoard_Quiz1` FOREIGN KEY (`Quiz_ID`) REFERENCES `Quiz` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION, CONSTRAINT `fk_ScoreBoard_User1` FOREIGN KEY (`User_ID`)  REFERENCES `User` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION, CONSTRAINT `fk_ScoreBoard_Technology1` FOREIGN KEY (`Technology_Title`) REFERENCES `Technology` (`Title`) ON DELETE NO ACTION ON UPDATE NO ACTION);  CREATE INDEX `fk_ScoreBoard_Quiz1_idx` ON `ScoreBoard` (`Quiz_ID` ASC);  CREATE INDEX `fk_ScoreBoard_Technology1_idx` ON `ScoreBoard` (`Technology_Title` ASC);"
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
    func initTech(){
        DBCRUD.initDBCRUD.createTechnology(r: "Java")
        DBCRUD.initDBCRUD.createTechnology(r: "Andriod")
        DBCRUD.initDBCRUD.createTechnology(r: "IOS")
    }
    
}
    
