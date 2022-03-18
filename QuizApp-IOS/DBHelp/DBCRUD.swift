//
//  DBCRUD.swift
//  QuizApp-IOS
//
//  Created by admin on 3/16/22.
//

import Foundation
import SQLite3
class DBCRUD{
    static let initDBCRUD = DBCRUD()
    private init(){}
var db = DBInit.db
//USER
        //create
    func createUserWithUserModal(us: UserModels){
        //if this is a blank user then don't add
        if us.Password == ""{
            return
        }
        //variable for template generation opetion
        var labels:String=""
        var arguments:String=""
        //init template
        var query = "INSERT INTO User ("
            var stmt : OpaquePointer?
        //template appender
        if !us.Email.isEmpty{
            
        }
        if us.UserName != ""{
            labels+="UserName, "
            arguments+=us.UserName!+", "
        }
        if us.Password != ""{
            labels+="Password, "
            arguments+=us.Password+", "
        }
        if us.Dob != ""{
            labels+="Dob, "
            arguments+=us.Dob!+", "
        }
        if us.admin == true{
            labels+="admin, "
            arguments+="1, "
        }
        if us.Subscript != ""{
            labels+="subcription, "
            arguments+=us.Subscript+", "
        }
        if us.status != ""{
            labels+="Status, "
            arguments+=us.status+", "
        }
        if us.First != ""{
            labels+="First, "
            arguments+=us.First!+", "
        }
        if us.Last != ""{
            labels+="Last, "
            arguments+=us.Last!+", "
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        //format template
        let c = labels.index(labels.endIndex, offsetBy: -2)
        labels=String(labels.prefix(upTo: c))
        let a = arguments.index(arguments.endIndex, offsetBy: -2)
        arguments=String(arguments.prefix(upTo: a))
        
        query+=labels+") VALUES("+arguments+")"
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        let id=UserCount()
        for a in us.Email{
            CreateEmail(ID: id, NE: a)
        }
    }
    
//read
    func UserCount()->Int{
        var i = 0
        let query = "select COUNT() from User"
            var stmt : OpaquePointer?
        
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return i
            }
        if(sqlite3_step(stmt) == SQLITE_ROW){
             i = Int(sqlite3_column_int(stmt, 0))
        }
        return i
    }
func UserIDToPassword(id:Int) -> String{
    let query = "select Password from User WHERE ID = ?"
        var stmt : OpaquePointer?
    
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return ""
        }
    //bind
    if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return ""
    }
    
    var password: String = ""
    //step
    //Appending Emails to Array
        if(sqlite3_step(stmt) == SQLITE_ROW){
             password = String(cString: sqlite3_column_text(stmt, 0))
        }
        return password
    
}
func UserIDToUser(id:Int) -> UserModels{
    let query = "select * FROM User WHERE ID = ?"
    var stmt : OpaquePointer?
    
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return UserModels()
    }
//bind
if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
    let err = String(cString: sqlite3_errmsg(db)!)
    print("There is an Error:",err)
    return UserModels()
}
    var user: UserModels?
    if(sqlite3_step(stmt) == SQLITE_ROW){
        //get data
        let id = Int(sqlite3_column_int(stmt, 0))
        
        
        user = UserModels(ID: id, UserName: String(cString : sqlite3_column_text(stmt, 2)), Password: String(cString : sqlite3_column_text(stmt, 3)), DOB: String(cString : sqlite3_column_text(stmt, 4)), admin: Int(sqlite3_column_int(stmt, 5)) == 1, subriction: String(cString : sqlite3_column_text(stmt, 6)), Status: String(cString : sqlite3_column_text(stmt, 7)), First: String(cString : sqlite3_column_text(stmt, 8)), Last: String(cString : sqlite3_column_text(stmt, 9)), email: UserIDtoEmail(ID: id))
    }
    return user ?? UserModels()
    
}
    //Update
    func updateUser(us:UserModels){
        
        let query = "UPDATE User set "
        var arguments=""
        if us.UserName != ""{
            arguments+="UserName = "+us.UserName!+", "
        }
        if us.Password != ""{
        
            arguments+="Password = "+us.Password+", "
        }
        if us.Dob != ""{
            arguments+="Dob = "+us.Dob!+", "
        }
        if us.admin == true{
            arguments+="admin = "+"1, "
        }
        if us.Subscript != ""{
            arguments+="subcription = "+us.Subscript+", "
        }
        if us.status != ""{
            
            arguments+="Status = "+us.status+", "
        }
        if us.First != ""{
            arguments+="First = "+us.First!+", "
        }
        if us.Last != ""{
            arguments+="Last = "+us.Last!+", "
        }
        let c = arguments.index(arguments.endIndex, offsetBy: -2)
        arguments=String(arguments.prefix(upTo: c))
        arguments+="WHERE ID = ?"
    var stmt : OpaquePointer?

    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_int(stmt, 1, Int32(us.ID!)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
        deleteAllEmail(NE: us.ID!)
        for i in us.Email{
            CreateEmail(ID: us.ID!, NE: i)}
     
    }
    //delete
    func DeleteUser(ID: Int){
        let query = "DELETE * FROM User WHERE ID = ?"
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_int(stmt, 1, Int32(ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Email
//create
func CreateEmail(ID:Int,NE:String){
    let query = "insert into Emails (Emails, User_ID) VALUES (?,?)"
    var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return
        }
    //bind
    let n = (NE as NSString)
    if sqlite3_bind_text(stmt, 1, (n).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
    if sqlite3_bind_int(stmt, 2, Int32(ID)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
}
//read
func EmailToUserID(NE:String) -> Int{
    let query = "select User_ID from Emails WHERE Emails = ?"
        var stmt : OpaquePointer?
    
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
    //bind
    if sqlite3_bind_text(stmt, 1, (NE as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return -1
    }
    var id: Int = -1
    //step
    //Appending Emails to Array
        if(sqlite3_step(stmt) == SQLITE_ROW){
             id = Int(sqlite3_column_int(stmt, 0))
        }
        return id
    
        
}
func UserIDtoEmail(ID:Int)->[String]{
    var emails = [String]()
    let query = "SELECT Email FROM Emails WHERE User_ID = ?"
        var stmt : OpaquePointer?
    
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return emails
        }
    
    if sqlite3_bind_int(stmt, 1, Int32(ID)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return emails
    }
    while(sqlite3_step(stmt) == SQLITE_ROW){
        emails.append(String(cString: sqlite3_column_text(stmt, 0)))
    }
    return emails
}
    //update
func replaceEmail(NE:String,OE:String){
        let query = "UPDATE Emails set Email = ? WHERE Email = ?"
    var stmt : OpaquePointer?

    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 1, (NE as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 2, (OE as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    }
//Delete
func deleteAEmail(NE:String){
    let query = "DELETE * FROM Emails WHERE Email = ?"
var stmt : OpaquePointer?
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 1, (NE as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
}
func deleteAllEmail(NE:Int){
    let query = "DELETE * FROM Emails WHERE User_ID = ?"
var stmt : OpaquePointer?
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    
    if sqlite3_bind_int(stmt, 1, Int32(NE)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//REVIEW
//create
    func createReview(r:ReviewModels){
        let query = "INSERT INTO Review (rate, comments, User_ID) Values(?,?,?)"
        var stmt : OpaquePointer?

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return
            }
        if sqlite3_bind_int(stmt, 0, Int32(r.rate)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return
        }
        if sqlite3_bind_text(stmt, 1, (r.comments as! NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return}
        if sqlite3_bind_int(stmt, 2, Int32(r.User_ID!)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
    }
//read
    func ReviewCount()->Int{
        var i = 0
        let query = "select COUNT() from Review"
            var stmt : OpaquePointer?
        
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return i
            }
        if(sqlite3_step(stmt) == SQLITE_ROW){
             i = Int(sqlite3_column_int(stmt, 0))
        }
        return i
    }
    func getReview(id:Int)->ReviewModels{
        let query = "select * from Review WHERE idReviews = ?"
            var stmt : OpaquePointer?
        
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return ReviewModels()
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return ReviewModels()
        }
        var rev: ReviewModels=ReviewModels()
        //step
        //Appending Emails to Array
            if(sqlite3_step(stmt) == SQLITE_ROW){
                 rev = ReviewModels(rate: Int(sqlite3_column_int(stmt, 0)), comments: String(cString: sqlite3_column_text(stmt, 1)), idReviews: Int(sqlite3_column_int(stmt, 2)), User_ID: Int(sqlite3_column_int(stmt, 3)))
            }
            return rev
    }
    
    func getUserReview(id:Int)->[ReviewModels]{
        let query = "select * from Review WHERE User_ID = ?"
        var ReviewArray = [ReviewModels]()
            var stmt : OpaquePointer?
        
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return ReviewArray
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return ReviewArray
        }
        
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                 let rev = ReviewModels(rate: Int(sqlite3_column_int(stmt, 0)), comments: String(cString: sqlite3_column_text(stmt, 1)), idReviews: Int(sqlite3_column_int(stmt, 2)), User_ID: Int(sqlite3_column_int(stmt, 3)))
                ReviewArray.append(rev)
            }
            return ReviewArray
    }
//update
    func updateReview(r:ReviewModels){
        let query = "UPDATE Review set rate = ?, comments = ? WHERE idReviews = ?"
    var stmt : OpaquePointer?

    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_int(stmt, 1, Int32(r.rate)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_text(stmt, 2, (r.comments as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_int(stmt, 3, Int32(r.idReviews!)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
        
    }
//delete
    func deleteAllUserReviews(NE:Int){
        let query = "DELETE * FROM Reviews WHERE User_ID = ?"
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(NE)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        
    }
    func deleteAReview(NE:Int){
        let query = "DELETE * FROM Reviews WHERE idReviews = ?"
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(NE)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Technology
    //create
    func createTechnology(r:String){
        
            let query = "INSERT INTO Technology (Title) Values(?)"
            var stmt : OpaquePointer?

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
            
            if sqlite3_bind_text(stmt, 0, (r as! NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return}
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
           
    }
   /* //read
    //update
    func updateTechology(NE:String,OE:String){
        
    }
    //delete
    func deleteATechnology(NE:Int){
        let query = "DELETE * FROM Reviews WHERE ID = ?"
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(NE)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        
    }*/
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//QUIZ
    //create
        func createReview(r:QuizModels){
            let query = "INSERT INTO Quiz (Title, Technology_Title) Values (?,?)"
            var stmt : OpaquePointer?

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
            
        if sqlite3_bind_text(stmt, 0, (r.Title as! NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return}
            
            if sqlite3_bind_text(stmt, 1, (r.Technology_Title as! NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return}
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
      
        func getQuiz(id:Int)->QuizModels{
            let query = "select * from Quiz WHERE ID = ?"
                var stmt : OpaquePointer?
            
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return QuizModels()
                }
            //bind
            if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return QuizModels()
            }
            var rev: QuizModels=QuizModels()
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 1)),  ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString: sqlite3_column_text(stmt, 3)))
                }
                return rev
        }
    func getQuizFromTechnology_Title(id:String)->[QuizModels]{
        let query = "select * from Quiz WHERE Technology_Title = ?"
            var stmt : OpaquePointer?
        var rev: [QuizModels]=[QuizModels]()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_text(stmt, 1, (id as! NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                var r:QuizModels = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 1)),  ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString: sqlite3_column_text(stmt, 3)))
                rev.append(r)
            }
            return rev
    }
    //update
        func updateQuiz(r:QuizModels){
            let query = "UPDATE Quiz set Title = ?, Technology_Title = ? WHERE ID = ?"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
                if sqlite3_bind_text(stmt, 1, (r.Title as! NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_text(stmt, 2, (r.Technology_Title as! NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_bind_int(stmt, 3, Int32(r.ID!)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
            
        }
    //delete
        
        func deleteAQuiz(NE:Int){
            let query = "DELETE * FROM Quiz WHERE ID = ?"
        var stmt : OpaquePointer?
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(NE)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
            
        }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Questions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PRIZE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Scoreboard
}
