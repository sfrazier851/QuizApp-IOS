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
    
    
    var user: User?
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
        UserName.text = user?.Name
        
        Android_Score.text = user?.Android_Score
        iOS_Score.text = user?.iOS_Score
        Java_Score.text = user?.Java_Score
    }
    
    
    @IBAction func GiveSub(_ sender: Any)
    {
    }
    
    @IBAction func Ban(_ sender: Any)
    {
    }
}

extension AdminUserDetails: UserSelectionDelegate
{
    func UserSelected(_ NextUser: User)
    {
        user = NextUser
    }
}
