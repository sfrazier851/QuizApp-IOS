
//############################
//Title:DBCRUD
//Purpose:To contain all CRUD functionality
//Author:Andrew Malmstead
//Date: 3/28/2022
/*Notes:
&& = Create
$$ = Read
@@ = Update
%% = Delete
*/
//#############################

import Foundation
import SQLite3
class DBCRUD{
    static let initDBCRUD = DBCRUD()
    private init(){}
var db = DBInit.db
//USER
        //create
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//Purpose: To create a user inside the database with a given User Modal
/*Methodology: The function returns true if we were able to insert a user into the table, false otherwise on failure. It takes apart the user models properties
and insert them into the values of the querry to thier respective column.
*/
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
        //prepare
        let query = "INSERT INTO User (UserName, Password, Dob, admin, subcription, Status, First, Last) VALUES (?,?,?,?,?,?,?,?)"
            var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error createUserWithUserModal prepare:",err)
            flag = false
        }
        
       //bind
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

        //step
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error createUserWithUserModal step:",err)
            flag = false
        }
        //assign all the email in the userModel to
        let id=UserCount()
        for a in us.Email{
            CreateEmail(ID: id, NE: a)
        }
        
        return flag
    }
    
//read
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//Purpose: Returns the amount of users in the user table.
/*Methodology:
Uses a query to count all the rows in the user table
*/
    func UserCount()->Int{
        var i = 0
        let query = "select COUNT() from User"
            var stmt : OpaquePointer?
        //prepare
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return i
            }
        //step
        if(sqlite3_step(stmt) == SQLITE_ROW){
             i = Int(sqlite3_column_int(stmt, 0))
        }
        return i
    }
//Purpose:To return the password of a particular user with a given user ID
/*Methodology: The fuction takes the User ID and binds it to a query that select the password in a given row
*/
func UserIDToPassword(id:Int) -> String{
    let query = "select Password from User WHERE ID = ?"
        var stmt : OpaquePointer?
    //prepare
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
        if(sqlite3_step(stmt) == SQLITE_ROW){
             password = String(cString: sqlite3_column_text(stmt, 0))
        }
        return password
}
//Purpose:To return a user Model based on a given User ID
/*Methodology: The given user ID is binded to the query where it selects a row in the user table. With the given row we break its columns into the user model contstructor
*/
    func UserIDToUser(id:Int) -> UserModels{
        let query = "select * FROM User WHERE ID = ?"
        var stmt : OpaquePointer?
        // prepare
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
        //step
        if(sqlite3_step(stmt) == SQLITE_ROW){
            //get data
            let id = Int(sqlite3_column_int(stmt, 0))
            user = UserModels(ID: id, UserName: String(cString : sqlite3_column_text(stmt, 1)), Password: String(cString : sqlite3_column_text(stmt, 2)), DOB: String(cString : sqlite3_column_text(stmt, 3)), admin: Int(sqlite3_column_int(stmt, 4)) == 1, subriction: Int(sqlite3_column_int(stmt, 5)), Status: String(cString : sqlite3_column_text(stmt, 6)), First: String(cString : sqlite3_column_text(stmt, 7)), Last: String(cString : sqlite3_column_text(stmt, 8)), email: UserIDtoEmail(ID: id))
        }
        return user ?? UserModels()
        
    }
    //Purpose:To return an array of user models that match all users inside the table
/*Methodology: The query select everything in the user table then takes each row and breaks it columns into the user model constructor.
*/
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
    //Purpose:To return the subscription state of a particular user
/*Methodology:Take a user ID and binds it into the query. The query select the subcription with a particular User ID and returns it.
*/
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
    //Purpose:To get the number of attempt a user scored in a day
/*Methodology: The query counts the amount of rows in scoreboard that match a particular user ID on a particular day. -1 if there are none.
*/
    func getNumberOfAttempts(id:Int, date: String) -> Int {
        
        let query = "Select COUNT(User_ID) as NumberOfAttempts FROM Scoreboard WHERE User_ID = ? AND TakenDate = ?"
        var stmt : OpaquePointer?
        //prepare
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
        //step
        if(sqlite3_step(stmt) == SQLITE_ROW){
            //get data
            num = Int(sqlite3_column_int(stmt, 0))
        }
        
        return num
        
    }

    
    //Update
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //Purpose:To update a user
/*Methodology:The function takes a user model and uses its' User ID to determine which user to update. With the selected user the user model is broken into
componets matching each of the column in a user row.
*/
    func updateUser(us:UserModels){

        let query = "UPDATE User set UserName = ?, Password = ?, Dob = ?, admin = ?, subcription = ?, Status = ?, First = ?, Last = ? WHERE ID = ?"
        
    var stmt : OpaquePointer?
    //prepare
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error updateUser prepare:",err)
        }
        //bind
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
    //step
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    //update the email list that match this user
        deleteAllEmail(NE: us.ID!)
        for i in us.Email{
            CreateEmail(ID: us.ID!, NE: i)}
     
    }
    //delete
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //Purpose: To delete user with a given user ID
/*Methodology: With the given ID we delete any entries in the user table 
*/
    func DeleteUser(ID: Int){
        let query = "DELETE FROM User WHERE ID = ?"
    var stmt : OpaquePointer?
    //prepare
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        //bind
        if sqlite3_bind_int(stmt, 1, Int32(ID)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        //step
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
    }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Email
//create
//Purpose: To create a email inside the database with a given User Modal
/*Methodology: It takes some User and Email to be inserted into the email table.
*/
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
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
//Purpose:To return a User ID that matches to a specific email
/*Methodology: With the given email, it is bind to the query to seach in the email table for a particular email and return the User ID that it matches too
*/
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
//Purpose:check if a user already exists with a particular username
/*Methodology:With the given User name we count all the rows in the user table that match it then we return the count
*/
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
    
    //Purpose:To return an array of emails for a given user
/*Methodology:With the given user ID we select all emails that contain it then return them.
*/
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
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//Purpose:To replace an old email with a new email.
/*Methodology: The query uses the old email to select a row in the email table to update with the new given email
*/
func replaceEmail(NE:String,OE:String){
        let query = "UPDATE Emails set Email = ? WHERE Email = ?"
    var stmt : OpaquePointer?
//prepare
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    //bind
    if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    if sqlite3_bind_text(stmt, 2, (OE as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    //step
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    }
//Delete
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//Purpose: To delete a particular email
/*Methodology: The function uses the email in the query to select any rows in the email table to delete
*/
func deleteAEmail(NE:String){
    let query = "DELETE FROM Emails WHERE Email = ?"
var stmt : OpaquePointer?
//prepare
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    //bind
    if sqlite3_bind_text(stmt, 1, (NE as NSString).utf8String, -1, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    //step
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
    
}
//Purpose:To delete all emails that are associated with a given User ID
/*Methodology: The query takes the User ID to select all rows in the email table that matches each email to particular User for deletion
*/
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//Purpose:To take a Review model and insert a review into the table 
/*Methodology:With the given Review model we break into each of its properties that match each column of the review row then we insert it into the database
*/
    func createReview(r:ReviewModels) -> Bool {
        
        let query = "INSERT INTO Reviews (rate, comments, User_ID) Values(?,?,?)"
        var stmt : OpaquePointer?
//prepare
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        //bind
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
        //step
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return false
        }
        
        return true
        
    }
//read
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    //Purpose:To return the number of reviews
/*Methodology: the function counts each row in the reviews table and returns the count
*/

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
    //Purpose:to return a review model thaat matches its ID
/*Methodology:With the given ID select a row from the review table that match it and break its column into properties for the review model
*/

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
    //Purpose: To return an array of reviews that associate with a given User ID
/*Methodology:With the given User ID select all rows in the review table. append each row as a review model into an array and return it.
*/
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
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//Purpose: To update a review with a given review model
/*Methodology: With the given Review model we use it's ID property to select the row of review that it associates with it. With the row we update it column with 
the models properties
*/
    func updateReview(r:ReviewModels){
        let query = "UPDATE Review set rate = ?, comments = ? WHERE idReviews = ?"
    var stmt : OpaquePointer?
//prepare
    if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
    //bind
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
    //step
    if sqlite3_step(stmt) != SQLITE_DONE{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    
    }
        
    }
//delete
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   //Purpose:To delete all review that are associated with a given user ID
/*Methodology:It takes the user ID and select the rows that associate with that user ID for deletion.
*/
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
    //Purpose: To delete a particular review
/*Methodology:It take the review ID and uses it to select any rows with that given review ID to delete
*/
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//Purpose: To create a technology in the table
/*Methodology:The function takes a string to insert into the technology table
*/
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//QUIZ
    //create
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

//Purpose: To insert a quiz row into the quiz table that match a given quiz model
/*Methodology: With the given properties from the quiz model we insert them into the columns that match it and insert it into the table
*/
        func createQuiz(r:QuizModels)->Int{
            let query = "INSERT INTO Quiz (Title, Technology_Title) Values (?,?)"
            var stmt : OpaquePointer?
let i = -1
//prepare
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return i
                }
         //bind   
            if sqlite3_bind_text(stmt, 1, (r.Title as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return i}
            
            if sqlite3_bind_text(stmt, 2, (r.Technology_Title as NSString).utf8String, -1, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
                return i }
            //step
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            return i
            }
            return Int(sqlite3_last_insert_rowid(db))
        }
    //read
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$      
       //Purpose: To get a quiz in the quiz table and construct it into a quiz model
/*Methodology: With the given quiz ID we select a row that get broken into columns that are used in the quiz model constructor.
*/
        func getQuiz(id:Int)->QuizModels{
            let query = "select * from Quiz WHERE ID = ?"
                var stmt : OpaquePointer?
            //prepare
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
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 0)),  ID: Int(sqlite3_column_int(stmt, 1)), Technology_Title: String(cString: sqlite3_column_text(stmt, 2)))
                }
                return rev
        }
        //Purpose: To return an array of quiz that corrspond to a particular technology
/*Methodology: With the given Technology title get select all rows in the quiz table that has that technology and use the quiz model constructor on each row to append
into an array
*/

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
    //Purpose:To return a quiz model with a given title
/*Methodology:With the title given a row is selected that matches it in the quiz table then puts it into the quiz constroctor to return a quiz model
*/

      func getQuizByTitle(title:String, Technology_Title:String)->QuizModels?{
            let query = "select * from Quiz WHERE Title = ? AND Technology_Title = ?"
                var stmt : OpaquePointer?
            //prepare
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
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuizModels(Title: String(cString: sqlite3_column_text(stmt, 0)),  ID: Int(sqlite3_column_int(stmt, 1)), Technology_Title: String(cString: sqlite3_column_text(stmt, 2)))
                }
                return rev
        }
    //update
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//Purpose:To update a quiz with a given quiz model
/*Methodology: With the quiz model the id is extracted to select the quiz row in the quiz table to update its columns with the models properties
*/
        func updateQuiz(r:QuizModels){
            let query = "UPDATE Quiz set Title = ?, Technology_Title = ? WHERE ID = ?"
        var stmt : OpaquePointer?
        //prepare
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
         //bind   
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
            //step
        if sqlite3_step(stmt) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        
        }
            
        }
    //delete
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
//Purpose: To delete a quiz with a particular quiz ID
/*Methodology: With the given quiz ID we delete any row in the quiz table that has that quiz ID
*/
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
        //Purpose:To insert a new question and return its ID otherwise a negative is return to state it wasn't inserted
/*Methodology:With the given Question model that break its properties into columns for the question row to be inserted into the question table
*/

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
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$      
        //Purpose: With the given question ID return a constructed question model
/*Methodology:With the given question ID select a question row that contains it and break its columns into properties for the question model constructor
*/
        func getQuestion(id:Int)->QuestionModels{
            let query = "select * from Questions WHERE ID = ?"
                var stmt : OpaquePointer?
            var rev: QuestionModels=QuestionModels()
            //prepare
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
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = QuestionModels(Question: String(cString: sqlite3_column_text(stmt, 0)), Awnser: String(cString: sqlite3_column_text(stmt, 1)), Quiz_ID: Int(sqlite3_column_int(stmt, 2)), ID: Int(sqlite3_column_int(stmt, 3)))
                    }
                return rev
        }
    //Purpose: With the given question Title return a constructed question model
/*Methodology:With the given question Title select a question row that contains it and break its columns into properties for the question model constructor
*/
    func getQuestionByTitle(id:String)->QuestionModels{
        let query = "select * from Questions WHERE Question = ?"
            var stmt : OpaquePointer?
        var rev: QuestionModels=QuestionModels()
        //prepare
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
            if(sqlite3_step(stmt) == SQLITE_ROW){
                rev = QuestionModels(Question: String(cString: sqlite3_column_text(stmt, 0)), Awnser: String(cString: sqlite3_column_text(stmt, 1)), Quiz_ID: Int(sqlite3_column_int(stmt, 2)), ID: Int(sqlite3_column_int(stmt, 3)))
                }
            return rev
    }
  //Purpose: With the given quiz ID return a constructed question array model
/*Methodology:With the given quiz select all question row that contains it and break thier columns into properties for the question model constructor then append them into
an array
*/
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
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//Purpose: To update a question row with a question model
/*Methodology:With the given question extracts its ID to select a question row that contains it. With the selected row update its columns with the properties of the model
*/
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
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //Purpose: To delete a particular question with a given ID
/*Methodology: With the given question ID delete any question rows that have that question ID
*/
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//Purpose:Insert a choice with a given question ID
/*Methodology: With the given choice and question ID insert it into the choice table
*/
    func createChoice(Choice:String,ID:Int){

            let query = "INSERT INTO choices (choice, Questions_ID) Values (?,?)"
            var stmt : OpaquePointer?
//prepare
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
         //bind   
        if sqlite3_bind_text(stmt, 1, (Choice as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
            return}
        
            if sqlite3_bind_int(stmt, 2, Int32(ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        //step
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      //Purpose:To return all choices that are associated with a question
/*Methodology: With the question ID select all choice row that contain that question ID and return them as an array.
*/
    func getChoiceFromQuestionID(id:Int)->[String]{
        let query = "select * from choices WHERE Questions_ID = ?"
            var stmt : OpaquePointer?
        var rev: [String]=[String]()
//prepare
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
    
    
    //delete
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //Purpose:To delete all choices that are associated with a question ID
/*Methodology:With the given question ID we delete all choice row that has that question ID
*/
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//Purpose: To insert a prize into the pirze table that match a particular prize model
/*Methodology:It takes some prize model and break its properties into column to be inserted into a new row in prize table.
*/

    //create
    func createPrize(prize:Prize){
            let query = "INSERT INTO Prizes (GivenDate, StartDate, EndDate, active, Value, Type, User_ID) Values (?,?,?,?,?,?,?)"
            var stmt : OpaquePointer?
        //Prepare
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print("There is an Error:",err)
                    return
                }
            //bind
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
        
        if sqlite3_bind_int(stmt, 5, Int32(prize.value!)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        
        if sqlite3_bind_int(stmt, 6, Int32(prize.PrizeType)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        
        
        if sqlite3_bind_int(stmt, 7, Int32(prize.User_ID)) != SQLITE_OK{ let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
            //step
            if sqlite3_step(stmt) != SQLITE_DONE{
                let err = String(cString: sqlite3_errmsg(db)!)
                print("There is an Error:",err)
            
            }
        }
    //read
    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
//Purpose:To return a prize model that match a particular 
/*Methodology:With the given prize ID get a row from the prize table with that prize ID and break it column into the prize model contstructor
*/
    func getPrizeFromPrizeID(id:Int)->Prize{
        let query = "select * from Prizes WHERE idPrizes = ?"
            var stmt : OpaquePointer?
        var rev: Prize = Prize()
//prepare
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
            if(sqlite3_step(stmt) == SQLITE_ROW){
                rev = Prize(idPrize: Int(sqlite3_column_int(stmt, 0)), GivenDate:String(cString:sqlite3_column_text(stmt, 1)) ,startDate: String(cString:sqlite3_column_text(stmt, 2)), EndaDate: String(cString:sqlite3_column_text(stmt, 3)), PrizeType: Int(sqlite3_column_int(stmt, 4)), User_ID: Int(sqlite3_column_int(stmt, 5)), active: Int(sqlite3_column_int(stmt, 6)),value: Int(sqlite3_column_int(stmt, 7)))
                
            }
            return rev
    }
//Purpose:To return a prize model that match a particular 
/*Methodology:With the given prize ID get a row from the prize table with that prize ID and break it column into the prize model contstructor
*/
    func getPrizeFromUserID(id:Int)->[Prize]{
        let query = "select * from Prizes WHERE User_ID = ?"
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
    //Purpose:To return an array prize model  
/*Methodology:
*/
    func getPrizeFromUserIDinGivenDayByType(id:Int, type:Int=9, day:Date?=nil)->[Prize]{
        var query = "select * from Prizes WHERE User_ID = ?"
            var stmt : OpaquePointer?
        var rev: [Prize] = [Prize]()
        if day != nil{
            query += " AND GivenDate = ?"
        }
        if type != 9{
            query += " AND Type = ?"
        }
        var count=2
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
        if day != nil{
            if sqlite3_bind_text(stmt, 1, ( Utilities.DatetoString(day: day!) as NSString).utf8String, -1, nil) != SQLITE_OK{
                       let err = String(cString: sqlite3_errmsg(db)!)
                       print("There is an Error:",err)
                       }
            
            count+=1
        }
        if type != 9{
            if sqlite3_bind_int(stmt, Int32(count), Int32(type)) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
                return rev
        }
            count+=1
        }
        //step
        //Appending Emails to Array
            while(sqlite3_step(stmt) == SQLITE_ROW){
                rev.append( Prize(GivenDate:String(cString:sqlite3_column_text(stmt, 0)) ,startDate: String(cString:sqlite3_column_text(stmt, 1)), EndaDate: String(cString:sqlite3_column_text(stmt, 2)), PrizeType: Int(sqlite3_column_int(stmt, 3)), User_ID: Int(sqlite3_column_int(stmt, 4)), active: Int(sqlite3_column_int(stmt, 5))))
                
            }
            return rev
    }
    func getLatestActivePrize(UserID:Int)->[Prize]{
        var prize:[Prize] = [Prize]()
        let query = "SELECT * FROM Prizes WHERE active = 1 AND User_ID = ? ORDER BY EndDate DESC ;"
                 var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_int(stmt, 1, Int32(UserID)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            prize.append( Prize(GivenDate:String(cString:sqlite3_column_text(stmt, 0)) ,startDate: String(cString:sqlite3_column_text(stmt, 1)), EndaDate: String(cString:sqlite3_column_text(stmt, 2)), PrizeType: Int(sqlite3_column_int(stmt, 3)), User_ID: Int(sqlite3_column_int(stmt, 4)), active: Int(sqlite3_column_int(stmt, 5))))
        }
        return prize
    }
    func getActivePrize(active:Int = 1, UserID:Int)->[Prize]{
        var prize:[Prize] = [Prize]()
        
        let query = "select * from Prizes WHERE active = ? AND User_ID = ?"
                 var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an Error:",err)
        }
        if sqlite3_bind_int(stmt, 1, Int32(active)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        if sqlite3_bind_int(stmt, 2, Int32(UserID)) != SQLITE_OK{
        let err = String(cString: sqlite3_errmsg(db)!)
        print("There is an Error:",err)
    }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            prize.append( Prize(GivenDate:String(cString:sqlite3_column_text(stmt, 0)) ,startDate: String(cString:sqlite3_column_text(stmt, 1)), EndaDate: String(cString:sqlite3_column_text(stmt, 2)), PrizeType: Int(sqlite3_column_int(stmt, 3)), User_ID: Int(sqlite3_column_int(stmt, 4)), active: Int(sqlite3_column_int(stmt, 5))))
            
        }
        return prize
    }
    
    //update
    func updatePrize(prize:Prize){
            let query = "UPDATE Prizes set GivenDate = ?, StartDate = ?, EndDate = ?, active = ?, Type = ?, User_ID = ?, Value = ? WHERE idPrizes = ?"
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
        
        if sqlite3_bind_int(stmt, 5, Int32(prize.PrizeType)) != SQLITE_OK{
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
        if sqlite3_bind_int(stmt, 8, Int32(prize.value!)) != SQLITE_OK{
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
    func getSumScoreOfUser(User_ID:Int, Technology_Title:String="")->Int{
            var query=""
                var stmt : OpaquePointer?
            if Technology_Title != ""{
                query = "select Sum(Score) from Review GROUP BY USER_ID, Technology_Title WHERE User_ID = ? AND Technology_Title = ?"
            }else{
                query = "select Sum(Score) from Review GROUP BY USER_ID WHERE User_ID = ?"
            }
        var rev: Int = 0

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
                                        rev = Int(sqlite3_column_int(stmt, 0))

                               
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
            query = "SELECT Rank FROM (SELECT Technology_Title, Sum(Score), User_ID, dense_rank () OVER (PARTITION By Technology_Title ORDER By Sum(score) DESC) as Rank FROM ScoreBoard  GROUP BY User_ID, Technology_Title ) Where User_ID = ? AND Technology_Title = ? LIMIT 10"
          }
        
                var stmt : OpaquePointer?
        var rev = 999999999

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
            let query = "SELECT Rank FROM (SELECT User_ID, DENSE_RANK() OVER (PARTITION By Technology_Title ORDER BY Score) as Rank FROM ScoreBoard WHERE Technology_Title = ? AND TakenDate = ? ) WHERE User_ID = ?"
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
    /*
     *Purpose: To rank the rank of a user in a particular quiz
     *Methodology: Takes the Quiz and User ID then bind it to the clause of the querry. The querry will group all the quizes and in each group the ranking will start there base
     *on the score then from this we select the rank for a given user.
     *
     */
    func getQuizRankOfUser(Quiz_ID:Int, User_ID:Int)->Int{
            let query = "SELECT Rank FROM(DENSE_RANK() OVER (PARTITION By Quiz_ID ORDER BY Score) Rank WHERE Quiz_ID = ? ) WHERE User_ID = ?"
                var stmt : OpaquePointer?
        //If remained the same there is an error.
        var rev = 9999999999999999
                //prepare
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
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    rev = Int(sqlite3_column_int(stmt, 0)) }
                return rev
        }
    /*
     *Purpose: To get all the scoremodels for a particular quiz
     *Methodology: The function takes the quiz ID to be bind to a que that select the whole row and encode it as a ScoreBoard models then append each row into an array that wil be return
     */
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
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    //append
                    rev .append( ScoreBoardModels(Score: Int(sqlite3_column_int(stmt, 0)), Quiz_ID:Int( sqlite3_column_int(stmt, 1)), User_ID: Int(sqlite3_column_int(stmt, 2)), Technology_Title: String(cString:sqlite3_column_text(stmt, 3)), TakenDate: String(cString:sqlite3_column_text(stmt, 4))))
                    
                }
                return rev
        /*
         *Purpose: To get all the scoremodels for a particular Technology
         *Methodology: The function takes the Technology title to be bind to a que that select the whole row and encode it as a ScoreBoard models then append each row into an array that wil be return
         */
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
    
}
