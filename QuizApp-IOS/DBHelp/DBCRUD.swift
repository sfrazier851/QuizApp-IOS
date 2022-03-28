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
    func createUserWithUserModal(us: UserModels) -> Bool {
        var flag = true
        print("createUserWithUserModal",us.First!,EmailToUserID(NE: us.Email[0]))
        //if this is a blank user then don't add
        if us.Password == ""{
            print("No Password Given")
            flag = false
        }
        if( EmailToUserID(NE: us.Email[0]) > -1){
            print("email already has user")
            flag = false
        }
        //init template
        let query = "INSERT INTO User (UserName, Password, Dob, admin, subcription, Status, First, Last) VALUES (?,?,?,?,?,?,?,?)"
            var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error createUserWithUserModal prepare:",err)
            flag = false
        }
        
       
        if sqlite3_bind_text(stmt, 1, (us.UserName! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        
        }
        if sqlite3_bind_text(stmt, 2, (us.Password as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        flag = false
        }
        if sqlite3_bind_text(stmt, 3, (us.Dob! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        }
        if sqlite3_bind_int(stmt, 4, Int32(Int(us.admin! ? 1:0))) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        }
        if sqlite3_bind_int(stmt, 5, Int32(us.Subscript)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        }
        if sqlite3_bind_text(stmt, 6, (us.status as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        
        }
        if sqlite3_bind_text(stmt, 7, (us.First! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        }
        if sqlite3_bind_text(stmt, 8, (us.Last! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            flag = false
        }

        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error createUserWithUserModal step:",err)
            flag = false
        }
        let id=UserCount()
        for a in us.Email{
            CreateEmail(ID: id, NE: a)
        }
        
        return flag
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
            
            
            user = UserModels(ID: id, UserName: String(cString : sqlite3_column_text(stmt, 1)), Password: String(cString : sqlite3_column_text(stmt, 2)), DOB: String(cString : sqlite3_column_text(stmt, 3)), admin: Int(sqlite3_column_int(stmt, 4)) == 1, subriction: Int(sqlite3_column_int(stmt, 5)), Status: String(cString : sqlite3_column_text(stmt, 6)), First: String(cString : sqlite3_column_text(stmt, 7)), Last: String(cString : sqlite3_column_text(stmt, 8)), email: UserIDtoEmail(ID: id))
        }
        return user ?? UserModels()
        
    }
    func AllUser() -> [UserModels]{
        let query = "select * FROM User"
        var stmt : OpaquePointer?
        var user: [UserModels]=[UserModels]()
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return user
        }
    
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //get data
            let id = Int(sqlite3_column_int(stmt, 0))
            
            
            user.append( UserModels(ID: Int(sqlite3_column_int(stmt, 0)), UserName: String(cString : sqlite3_column_text(stmt, 1)), Password: String(cString : sqlite3_column_text(stmt, 2)), DOB: String(cString : sqlite3_column_text(stmt, 3)), admin: Int(sqlite3_column_int(stmt, 4)) == 1, subriction: Int( sqlite3_column_int(stmt, 5)), Status: String(cString : sqlite3_column_text(stmt, 6)), First: String(cString : sqlite3_column_text(stmt, 7)), Last: String(cString : sqlite3_column_text(stmt, 8)), email: UserIDtoEmail(ID: id)))
        }
        return user
        
    }
    func getUserSubscription(id:Int) -> Int {
        
        let query = "Select subcription FROM User WHERE ID = ?"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
        
        var sub : Int = -1
        if(sqlite3_step(stmt) == SQLITE_ROW){
            //get data
            sub = Int(sqlite3_column_int(stmt, 0))
        }
        
        return sub
        
    }
    
    func getNumberOfAttempts(id:Int, date: String) -> Int {
        
        let query = "Select COUNT(User_ID) as NumberOfAttempts FROM Scoreboard WHERE User_ID = ? AND TakenDate = ?"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
        
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
        
        if sqlite3_bind_text(stmt, 2, (date as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return -1
        }
        
        var num : Int = -1
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            //get data
            num = Int(sqlite3_column_int(stmt, 0))
        }
        
        return num
        
    }

    
    //Update
    func updateUser(us:UserModels){

        let query = "UPDATE User set UserName = ?, Password = ?, Dob = ?, admin = ?, subcription = ?, Status = ?, First = ?, Last = ? WHERE ID = ?"
        
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error updateUser prepare:",err)
        }
        if sqlite3_bind_text(stmt, 1, (us.UserName! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_text(stmt, 2, (us.Password as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_text(stmt, 3, (us.Dob! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_int(stmt, 4, Int32(Int(us.admin! ? 1:0))) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_int(stmt, 5, Int32(us.Subscript)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_text(stmt, 6, (us.status as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_text(stmt, 7, (us.First! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_text(stmt, 8, (us.Last! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        if sqlite3_bind_int(stmt, 9, Int32(us.ID!)) != SQLITE_OK{
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
        let query = "DELETE FROM User WHERE ID = ?"
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
    if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
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
    
// check if a user already exists with a particular username
func usernameIsUnique(username:String) -> Bool{
    let query = "select COUNT(*) from User WHERE UserName = '\(username)'"
        var stmt : OpaquePointer?
        var count = 0
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        //step
        if(sqlite3_step(stmt) == SQLITE_ROW){
             count = Int(sqlite3_column_int(stmt, 0))
        }
        return count == 0
}
    
    
func UserIDtoEmail(ID:Int)->[String]{
    var emails = [String]()
    let query = "SELECT Emails FROM Emails WHERE User_ID = ?"
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
    if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 2, (OE as NSString).utf8String, -1, nil) != SQLITE_OK{
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
    let query = "DELETE FROM Emails WHERE Email = ?"
var stmt : OpaquePointer?
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
}
func deleteAllEmail(NE:Int){
    print("delete all email")
    let query = "DELETE FROM Emails WHERE User_ID = ?"
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
    func createReview(r:ReviewModels) -> Bool {
        
        let query = "INSERT INTO Reviews (rate, comments, User_ID) Values(?,?,?)"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(r.rate)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        
        }
        
        if sqlite3_bind_text(stmt, 2, (r.comments as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        
        if sqlite3_bind_int(stmt, 3, Int32(r.User_ID!)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        
        return true
        
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
        if sqlite3_bind_text(stmt, 2, (r.comments as NSString).utf8String, -1, nil) != SQLITE_OK{
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
        let query = "DELETE FROM Reviews WHERE User_ID = ?"
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
        let query = "DELETE FROM Reviews WHERE idReviews = ?"
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
            
        if sqlite3_bind_text(stmt, 1, (r as NSString).utf8String, -1, nil) != SQLITE_OK{
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
        let query = "DELETE FROM Reviews WHERE ID = ?"
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
        func createQuiz(r:QuizModels)->Int{
            let query = "INSERT INTO Quiz (Title, Technology_Title) Values (?,?)"
            var stmt : OpaquePointer?
let i = -1
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return i
                }
            
            if sqlite3_bind_text(stmt, 1, (r.Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return i}
            
            if sqlite3_bind_text(stmt, 2, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return i }
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            return i
            }
            return Int(sqlite3_last_insert_rowid(db))
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
                    rev = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 0)),  ID: Int(sqlite3_column_int(stmt, 1)), Technology_Title: String(cString: sqlite3_column_text(stmt, 2)))
                }
                return rev
        }
    func getQuizsFromTechnology_Title(id:String)->[QuizModels]{
        let query = "select * from Quiz WHERE Technology_Title = ?"
            var stmt : OpaquePointer?
        var rev: [QuizModels]=[QuizModels]()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_text(stmt, 1, (id as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                let r:QuizModels = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 0)),  ID: Int(sqlite3_column_int(stmt, 1)), Technology_Title: String(cString: sqlite3_column_text(stmt, 2)))
                rev.append(r)
            }
            return rev
    }
      func getQuizByTitle(title:String, Technology_Title:String)->QuizModels?{
            let query = "select * from Quiz WHERE Title = ? AND Technology_Title = ?"
                var stmt : OpaquePointer?
            
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return nil
                }
            //bind
            if sqlite3_bind_text(stmt, 1, (title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return nil
            }
        if sqlite3_bind_text(stmt, 2, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return nil
            }
            var rev: QuizModels=QuizModels()
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 0)),  ID: Int(sqlite3_column_int(stmt, 1)), Technology_Title: String(cString: sqlite3_column_text(stmt, 2)))
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
            
            if sqlite3_bind_text(stmt, 1, (r.Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_text(stmt, 2, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
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
            let query = "DELETE FROM Quiz WHERE ID = ?"
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
    //create
        func createQuestion(r:QuestionModels)->Int{
            let query = "INSERT INTO Questions (Question, Awnser, Quiz_ID) Values (?,?,?)"
            var stmt : OpaquePointer?
var i = -1
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error prepare:",err)
                    return i
                }
            
            if sqlite3_bind_text(stmt, 1, (r.Question as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error bind1:",err)
            return i}
            
            if sqlite3_bind_text(stmt, 2, (r.Awnser as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error bind2:",err)
                return i}
            if sqlite3_bind_int(stmt, 3, Int32(r.Quiz_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error bind3:",err)
                return i
            }
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error result:",err)
            return i
            }
                i =    Int(sqlite3_last_insert_rowid(db))
            return i
        }
    //read
      
        func getQuestion(id:Int)->QuestionModels{
            let query = "select * from Questions WHERE ID = ?"
                var stmt : OpaquePointer?
            var rev: QuestionModels=QuestionModels()
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return rev
                }
            //bind
            if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
            
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuestionModels(Question: String(cString: sqlite3_column_text(stmt, 0)), Awnser: String(cString: sqlite3_column_text(stmt, 1)), Quiz_ID: Int(sqlite3_column_int(stmt, 2)), ID: Int(sqlite3_column_int(stmt, 3)))
                    }
                return rev
        }
    
    func getQuestionByTitle(id:String)->QuestionModels{
        let query = "select * from Questions WHERE Question = ?"
            var stmt : OpaquePointer?
        var rev: QuestionModels=QuestionModels()
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
       if sqlite3_bind_text(stmt, 1, (id as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        
        //step
        //Appending Emails to Array
            if(sqlite3_step(stmt) == SQLITE_ROW){
                rev = QuestionModels(Question: String(cString: sqlite3_column_text(stmt, 0)), Awnser: String(cString: sqlite3_column_text(stmt, 1)), Quiz_ID: Int(sqlite3_column_int(stmt, 2)), ID: Int(sqlite3_column_int(stmt, 3)))
                }
            return rev
    }

     func getQuestionsForQuiz(id:Int)->[QuestionModels]{
        let query = "select * from Questions WHERE Quiz_ID = ?"
            var stmt : OpaquePointer?
        var rev: [QuestionModels]=[QuestionModels]()
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
        
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                rev.append( QuestionModels(Question: String(cString: sqlite3_column_text(stmt, 0)), Awnser: String(cString: sqlite3_column_text(stmt, 1)), Quiz_ID: Int(sqlite3_column_int(stmt, 2)), ID: Int(sqlite3_column_int(stmt, 3))))
                }
            return rev
    }
    //update
        func updateQuestion(r:QuestionModels){
            let query = "UPDATE Questions set Question = ?, Awnser = ?, Quiz_ID = ? WHERE ID = ?"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
            if sqlite3_bind_text(stmt, 1, (r.Question as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_text(stmt, 2, (r.Awnser as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_bind_int(stmt, 3, Int32(r.Quiz_ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
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
        
        func DeleteAQuestion(NE:Int){
            let query = "DELETE FROM Questions WHERE ID = ?"
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //choice
    //create
    func createChoice(Choice:String,ID:Int){

            let query = "INSERT INTO choices (choice, Questions_ID) Values (?,?)"
            var stmt : OpaquePointer?

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
            
        if sqlite3_bind_text(stmt, 1, (Choice as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return}
        
            if sqlite3_bind_int(stmt, 2, Int32(ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
      
    func getChoiceFromQuestionID(id:Int)->[String]{
        let query = "select * from choices WHERE Questions_ID = ?"
            var stmt : OpaquePointer?
        var rev: [String]=[String]()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let r:String = String(cString: sqlite3_column_text(stmt, 0))
                rev.append(r)
            }
            return rev
    }
    //update
    func updateChoice(new:String,old:String){
            let query = "UPDATE Choices set choices = ? WHERE choice = ?"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
        if sqlite3_bind_text(stmt, 1, (new as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
        if sqlite3_bind_text(stmt, 2, (old as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
            
        }
    //delete
        
        func deleteAChoice(NE:String){
            let query = "DELETE FROM choices WHERE choice = ?"
        var stmt : OpaquePointer?
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
            
        }
    func deleteQuestionsChoice(ID:Int){
        let query = "DELETE FROM choices WHERE Questions_ID = ?"
    var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_int(stmt, 1, Int32(ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
        
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PRIZE
    //create
    func createPrize(prize:Prize){
            let query = "INSERT INTO Prizes (GivenDate, StartDate, EndDate, active, Type, User_ID) Values (?,?,?,?,?,?)"
            var stmt : OpaquePointer?
        
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
            
        if sqlite3_bind_text(stmt, 1, ( prize.GivenDate as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return}
        
        if sqlite3_bind_text(stmt, 2, (prize.StartDate! as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return}
        
        if sqlite3_bind_text(stmt, 3, (prize.EndaDate! as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
        return}
        
        if sqlite3_bind_int(stmt, 4, Int32(prize.active!)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        
        if sqlite3_bind_int(stmt, 5, Int32(prize.PrizeType!)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        
        if sqlite3_bind_int(stmt, 6, Int32(prize.User_ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
    func getPrizeFromPrizeID(id:Int)->Prize{
        let query = "select * from choices WHERE idPrizes = ?"
            var stmt : OpaquePointer?
        var rev: Prize = Prize()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
            return rev
    }
        //step
        //Appending Emails to Array
            if(sqlite3_step(stmt) == SQLITE_ROW){
                rev = Prize(GivenDate:String(cString:sqlite3_column_text(stmt, 0)) ,startDate: String(cString:sqlite3_column_text(stmt, 1)), EndaDate: String(cString:sqlite3_column_text(stmt, 2)), PrizeType: Int(sqlite3_column_int(stmt, 3)), User_ID: Int(sqlite3_column_int(stmt, 4)), active: Int(sqlite3_column_int(stmt, 5)))
                
            }
            return rev
    }
    
    func getPrizeFromUserID(id:Int)->[Prize]{
        let query = "select * from choices WHERE idPrizes = ?"
            var stmt : OpaquePointer?
        var rev: [Prize] = [Prize]()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
            return rev
    }
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                rev.append( Prize(GivenDate:String(cString:sqlite3_column_text(stmt, 0)) ,startDate: String(cString:sqlite3_column_text(stmt, 1)), EndaDate: String(cString:sqlite3_column_text(stmt, 2)), PrizeType: Int(sqlite3_column_int(stmt, 3)), User_ID: Int(sqlite3_column_int(stmt, 4)), active: Int(sqlite3_column_int(stmt, 5))))
                
            }
            return rev
    }
    //update
    func updatePrize(prize:Prize){
            let query = "UPDATE Prizes set GivenDate = ?, StartDate = ?, EndDate = ?, active = ?, Type = ?, User_ID = ? WHERE idPrizes = ?"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
        if sqlite3_bind_text(stmt, 1, (prize.GivenDate as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
        if sqlite3_bind_text(stmt, 2, (prize.StartDate! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_text(stmt, 3, (prize.EndaDate! as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        if sqlite3_bind_int(stmt, 4, Int32(prize.active!)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        
        if sqlite3_bind_int(stmt, 5, Int32(prize.PrizeType!)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_int(stmt, 6, Int32(prize.User_ID)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
           
    }
        if sqlite3_bind_int(stmt, 7, Int32(prize.idPrize!)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
           
    }
            
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
            
        }
    //delete
        
        func deleteAPrize(NE:Int){
            let query = "DELETE FROM Prizes WHERE idPrizes = ?"
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
//Scoreboard
    //create
        func createScore(r:ScoreBoardModels){
            let query = "INSERT INTO ScoreBoard (Score, Quiz_ID, User_ID, Technology_title, TakenDate) Values (?,?,?,?,?)"
            var stmt : OpaquePointer?

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString:sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                
            }

            if sqlite3_bind_int(stmt, 1, Int32(r.Score)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                
            }
            if sqlite3_bind_int(stmt, 2, Int32(r.Quiz_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                
            }
            if sqlite3_bind_int(stmt, 3, Int32(r.User_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                
            }
            if sqlite3_bind_text(stmt, 4, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                }
            
            if sqlite3_bind_text(stmt, 5, (r.TakenDate as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                }
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
        
    func getScoreOfUserAQuiz(Quiz_ID:Int, User_ID:Int)->ScoreBoardModels{
            let query = "select * from Review WHERE Quiz_ID = ? AND User_ID = ?"
                var stmt : OpaquePointer?
        var rev: ScoreBoardModels=ScoreBoardModels()

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return rev
                }
            //bind
            if sqlite3_bind_int(stmt, 1, Int32(Quiz_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        if sqlite3_bind_int(stmt, 2, Int32(User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 0)), Quiz_ID:Int( sqlite3_column_int(stmt, 1)), User_ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString:sqlite3_column_text(stmt, 3)), TakenDate: String(cString:sqlite3_column_text(stmt, 4)))                }
                return rev
        }
    
    func getScoreOfUser(User_ID:Int, Technology_Title:String="")->[ScoreBoardModels]{
        var query=""
            var stmt : OpaquePointer?
        if Technology_Title != ""{
            query = "select * from Review WHERE User_ID = ? AND Technology_Title = ?"
        }else{
            query = "select * from Review WHERE User_ID = ?"
        }
    var rev: [ScoreBoardModels]=[ScoreBoardModels]()

            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
        if Technology_Title != ""{
            if sqlite3_bind_text(stmt, 2, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                     let err = String(cString: sqlite3_errmsg(db)!)
                     print("There is an Erro bind1r:",err)
                     return rev}
            
        }
        
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                rev.append(ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 0)), Quiz_ID:Int( sqlite3_column_int(stmt, 1)), User_ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString:sqlite3_column_text(stmt, 3)), TakenDate: String(cString:sqlite3_column_text(stmt, 4))))
                           
                           }
            return rev
    }
    
    func getTacRankOfUser(Technology_Title:String, User_ID:Int)->Int{
        var query: String
        if Technology_Title == "" {
            //query = "Select * FROM ScoreBoard WHERE TakenDate = ? ORDER BY Score DESC LIMIT 10"
            query = "SELECT Rank FROM (SELECT Technology_Title, Sum(Score), User_ID, dense_rank () OVER (PARTITION By Technology_Title ORDER By Sum(score) DESC) as Rank FROM ScoreBoard  GROUP BY User_ID, Technology_Title ) Where User_ID = ?  LIMIT 10"
        } else {
            //query = "Select * FROM ScoreBoard WHERE Technology_Title = ? AND TakenDate = ? ORDER BY Score DESC LIMIT 10"
            query = "SELECT Rank FROM (SELECT Technology_Title, Sum(Score), User_ID, dense_rank () OVER (PARTITION By Technology_Title ORDER By Sum(score) DESC) as Rank FROM ScoreBoard  GROUP BY User_ID, Technology_Title ) Where User_ID = ? AND Technology_Title LIMIT 10"
          }
        
                var stmt : OpaquePointer?
        var rev = 999999999

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return rev
                }
            //bind
        if sqlite3_bind_text(stmt, 1, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev}
        if Technology_Title != ""{
        if sqlite3_bind_int(stmt, 2, Int32(User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
            
        }
            //step
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = Int(sqlite3_column_int(stmt, 0))              }
                return rev
        
        }
    func getTacRankDay(Technology_Title:String, Date:String,Limit:Int)->[ScoreBoardModels]{
        
        var query : String
        
        if Technology_Title == "" {
            //query = "Select * FROM ScoreBoard WHERE TakenDate = ? ORDER BY Score DESC LIMIT 10"
            query = "SELECT User_ID, SUM(Score) FROM ScoreBoard WHERE TakenDate = ? GROUP BY User_ID ORDER BY SUM(Score) DESC LIMIT \(Limit)"
        } else {
            //query = "Select * FROM ScoreBoard WHERE Technology_Title = ? AND TakenDate = ? ORDER BY Score DESC LIMIT 10"
            query = "SELECT User_ID, SUM(Score) FROM ScoreBoard WHERE Technology_Title = ? AND TakenDate = ? GROUP BY User_ID ORDER BY SUM(Score) DESC LIMIT \(Limit)"
          }
        
        //print("QUERY: \(query)")
        var stmt : OpaquePointer?
        var rev = [ScoreBoardModels]()

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
            //bind
        
        if Technology_Title != "" {
            if sqlite3_bind_text(stmt, 1, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
            
            if sqlite3_bind_text(stmt, 2, (Date as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
        } else {
            if sqlite3_bind_text(stmt, 1, (Date as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return rev
            }
          }
     
        //step
        //Appending Emails to Array
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let score = ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 1)), Quiz_ID: 0, User_ID: Int(sqlite3_column_int(stmt, 0)), Technology_Title: Technology_Title, TakenDate: Date)
            rev.append(score)}
        return rev
    
    }
    
    func getTacRankOfUser(Technology_Title:String, User_ID:Int, Date:String)->Int{
            let query = "SELECT Rank FROM (SELECT User_ID, DENSE_RANK() OVER (ORDER BY Score) as Rank FROM ScoreBoard WHERE Technology_Title = ? AND TakenDate = ? ) WHERE User_ID = ?"
                var stmt : OpaquePointer?
        var rev = 999999

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error prepare:",err)
                    return rev
                }
            //bind
        if sqlite3_bind_text(stmt, 1, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Erro bind1r:",err)
            return rev}
        
    if sqlite3_bind_text(stmt, 2, (Date as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error bind2:",err)
        return rev}
        if sqlite3_bind_int(stmt, 3, Int32(User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error bind3:",err)
            return rev
        }
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = Int(sqlite3_column_int(stmt, 0))              }
                return rev
        }
    
    func getQuizRankOfUser(Quiz_ID:Int, User_ID:Int)->Int{
            let query = "SELECT Rank FROM(DENSE_RANK() OVER (ORDER BY Score) Rank WHERE Quiz_ID = ? ) WHERE User_ID = ?"
                var stmt : OpaquePointer?
        var rev = 9999999999999999

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error prepare:",err)
                    return rev
                }
            //bind
        if sqlite3_bind_int(stmt, 1, Int32(Quiz_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error bind1:",err)
            return rev
        }
        if sqlite3_bind_int(stmt, 2, Int32(User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error bind2:",err)
            return rev
        }
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = Int(sqlite3_column_int(stmt, 0)) }
                return rev
        }

    func getScoreOfQuiz( Quiz_ID:Int)->[ScoreBoardModels]{
            let query = "select * from Review WHERE Quiz_ID = ?"
                var stmt : OpaquePointer?
        var rev:[ ScoreBoardModels]=[ScoreBoardModels]()

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return rev
                }
            //bind
           
        if sqlite3_bind_int(stmt, 1, Int32(Quiz_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return rev
        }
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev .append( ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 0)), Quiz_ID:Int( sqlite3_column_int(stmt, 1)), User_ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString:sqlite3_column_text(stmt, 3)), TakenDate: String(cString:sqlite3_column_text(stmt, 4))))
                    
                }
                return rev
        }
    func getScoreTchnologyQuiz(Technology_Title:String)->[ScoreBoardModels]{
            let query = "select * from Review WHERE Technology_Title = ?"
                var stmt : OpaquePointer?
        var rev:[ ScoreBoardModels]=[ScoreBoardModels]()

                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return rev
                }
            //bind
        
            if sqlite3_bind_text(stmt, 1, (Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            //step
            //Appending Emails to Array
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev .append( ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 0)), Quiz_ID:Int( sqlite3_column_int(stmt, 1)), User_ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString:sqlite3_column_text(stmt, 3)), TakenDate: String(cString:sqlite3_column_text(stmt, 4))))
                    
                }
                return rev
        }
    //update
        func updateScore(r:ScoreBoardModels){
            let query = "UPDATE ScoreBoard set Score = ? , Technology_title = ?, TakenDate = ? WHERE Quiz_ID = ? AND User_ID,  = ?"
        var stmt : OpaquePointer?

        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_bind_int(stmt, 1, Int32(r.Score)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_bind_text(stmt, 2, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            
                if sqlite3_bind_text(stmt, 3, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            if sqlite3_bind_int(stmt, 4, Int32(r.Quiz_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
            if sqlite3_bind_int(stmt, 5, Int32(r.User_ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
            
        }
    //delete
    func deleteAUserScore(User_ID:Int, Quiz_ID:Int){
            let query = "DELETE FROM ScoreBoard WHERE Quiz_ID = ? AND User_ID,  = ?"
        var stmt : OpaquePointer?
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(Quiz_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            if sqlite3_bind_int(stmt, 2, Int32(User_ID)) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
            
        }
}
    
