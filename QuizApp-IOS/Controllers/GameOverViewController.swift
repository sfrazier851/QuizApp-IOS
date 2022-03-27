//
//  GameOverViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/18/22.
//

import UIKit

class GameOverViewController: UIViewController {

    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var viewRankingBtn: UIButton!
    
    var score : Int = 0
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        score = 0

        var score : Int = 0

        switch K.currentPage.lowercased() {
            
            case "java":
                score = K.java_gamescore
            case "ios":
                score = K.ios_gamescore
            case "android":
                score = K.android_gamescore
            default:
                print("No available score")
            
        }
        
        let day:String = Utilities.formatDate(date: Date())
        //print("tech is",K.currentPage, " day is ",day, " user is",LoginPort.user!.ID!)
        let rank = DBCRUD.initDBCRUD.getTacRankOfUser(Technology_Title: K.currentPage, User_ID: LoginPort.user!.ID!, Date: day)
        gameOverLabel.text = "YOUR SCORE: \(score)\nRANKING: \(rank)th"
        
        if  K.user_subscription == 1 {
            viewRankingBtn.isHidden = true
        }
        

    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        //CHECK SUBSCRIPTION
        if DBCRUD.initDBCRUD.getNumberOfAttempts(id: (LoginPort.user?.ID!)!, date: Utilities.formatDate(date: Date())) >= 2 && K.user_subscription == 1 {
            
            let dialogMessage = UIAlertController(title: "Alert", message: "You already reached your daily maximum attempts. Upgrade to a paid subscription for unlimited attempts", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
               
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
        } else {
          
            if  K.user_subscription == 1 {
                K.dailyAttempt += 1
            }
            
            switch K.currentPage.lowercased() {
                
                case "java":
                    PresenterManager.shared.show(vc: .java)
                case "ios":
                    PresenterManager.shared.show(vc: .ios)
                case "android":
                    PresenterManager.shared.show(vc: .android)
                default:
                    print("No available view")
                
            }
        
          }
        
    }
    
    @IBAction func viewRankings(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .ranking)
        
    }
    
    
    @IBAction func goBackHome(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .userHome)
    }
    
    @IBAction func goMainPage(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .userHome)
        
    }
    
}
