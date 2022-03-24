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
        
        if DBCRUD.initDBCRUD.getUserSubscription(id: (LoginPort.user?.ID)!) == 1 {
            viewRankingBtn.isHidden = true
        }
        

    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        //CHECK SUBSCRIPTION
        if K.dailyAttempt == 2 {
            
            let dialogMessage = UIAlertController(title: "Alert", message: "You already reached your daily maximum attempts. Upgrade to a paid subscription for unlimited attempts", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
               
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
        } else {
          
            K.dailyAttempt += 1
            
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
    
    func saveScoreToDB() {
        
        let SM = ScoreBoardModels(Score: score, Quiz_ID: K.game_quiz_id, User_ID: K.user_id, Technology_Title: K.currentPage)
    
        print(SM.Score)
        print(SM.Quiz_ID)
        print(SM.User_ID)
        print(SM.Technology_Title)
        
        //let success = DBCRUD.initDBCRUD.createQuiz(r: SM)
        
    }
    
}

//extension UITextView {
//
//    func centerVertically() {
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
//        let positiveTopOffset = max(1, topOffset)
//        contentOffset.y = -positiveTopOffset
//    }
//
//}
