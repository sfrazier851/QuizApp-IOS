//
//  AdminUserDetails.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import UIKit

class AdminUserDetails: UIViewController {

    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var Android_Score: UILabel!
    @IBOutlet weak var iOS_Score: UILabel!
    @IBOutlet weak var Java_Score: UILabel!
    @IBOutlet weak var Subscription_Status: UILabel!
    
    @IBOutlet weak var UserBan: UIButton!
    @IBOutlet weak var UserPass: UITextField!
    
    @IBOutlet weak var Password: UILabel!
    
    var user: UserModels?
    {
        didSet
        {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func refreshUI()
    {
        loadViewIfNeeded()
        UserName.text = user!.UserName
        
//        var SM = [ScoreBoardModels]()
//        let day:String = Utilities.formatDate(date: Date())
//        SM = DBCRUD.initDBCRUD.getTacRankDay(Technology_Title: page, Date: day, Limit: 10)
        
        var asc = String(DBCRUD.initDBCRUD.getTacRankOfUser(Technology_Title: "Android", User_ID: user!.ID!))
        var isc = String(DBCRUD.initDBCRUD.getTacRankOfUser(Technology_Title: "IOS", User_ID: user!.ID!))
        var jsc = String(DBCRUD.initDBCRUD.getTacRankOfUser(Technology_Title: "Java", User_ID: user!.ID!))
        
        if asc == "999999999" {
            asc = "N/A"
        }
        
        if isc == "999999999" {
            isc = "N/A"
        }
        
        if jsc == "999999999" {
            jsc = "N/A"
        }
        
        Android_Score.text = asc
        iOS_Score.text = isc
        Java_Score.text = jsc
        
        switch(user?.Subscript)
        {
        case 0:
            Subscription_Status.text = "Paid"
        case 1:
            Subscription_Status.text = "Trial"
        case 2:
            Subscription_Status.text = "Prize"
        default:
            Subscription_Status.text = "Unknown"
        }
        
        if("BLOCKED" == user?.status)
        {
            UserBan.setTitle("Un-Ban", for: .normal);
        }
        else
        {
            UserBan.setTitle("Ban", for: .normal);
        }
        
        Password.text = user?.Password
        
    }
    
    @IBAction func UpdatePass(_ sender: Any)
    {
        var PassChange = UIAlertController(title: "Update Password", message: "This user's Password will be updated to \(self.UserPass.text)", preferredStyle: UIAlertController.Style.alert)
        
        PassChange.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in print("Password Changed to \(self.UserPass.text)"); self.PassChange(); self.Password.text = self.UserPass.text }))
    
        PassChange.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in print("Canceled") }))
    
        present(PassChange, animated: true, completion: nil);
    }
    
    func PassChange()
    {
        user?.Password = UserPass.text ?? "Password"
        user?.save()
    }
    
    @IBAction func GiveSub(_ sender: Any)
    {
        user?.Subscript = 0
        user?.save()
    }
    
    @IBAction func Ban(_ sender: Any)
    {
        if("BLOCKED" == user?.status)
        {
            var BanAlert = UIAlertController(title: "Un-Ban", message: "This user will be unbanned", preferredStyle: UIAlertController.Style.alert)
            
            BanAlert.addAction(UIAlertAction(title: "Unban", style: .destructive, handler: { (action: UIAlertAction!) in print("User Unbanned"); self.Banning(); self.UserBan.setTitle("Ban", for: .normal) }))
        
            BanAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in print("Canceled") }))
        
            present(BanAlert, animated: true, completion: nil);
        }
        else
        {
            var BanAlert = UIAlertController(title: "Ban", message: "This user will be Banned", preferredStyle: UIAlertController.Style.alert)
        
            BanAlert.addAction(UIAlertAction(title: "Ban", style: .destructive, handler: { (action: UIAlertAction!) in print("User Banned"); self.Banning(); self.UserBan.setTitle("Un-Ban", for: .normal) }))
        
            BanAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in print("Canceled") }))
        
            present(BanAlert, animated: true, completion: nil);
        }
    }
    
    func Banning()
    {
        user?.toggleBlock()
        user?.save()
    }
    
}

                                         
                                         
extension AdminUserDetails: UserSelectionDelegate
{
    func UserSelected(_ NextUser: UserModels)
    {
        user = NextUser
    }
}
