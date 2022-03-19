//
//  GameOverViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/18/22.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var gamescoreTextView: UITextView!
   
    override func viewDidLoad() {
    
        super.viewDidLoad()
        gamescoreTextView.text = "YOUR SCORE: \(K.ios_gamescore)\nRANKING: 16th"

    }

    override func viewDidLayoutSubviews() {
        
        gamescoreTextView.centerVertically()
        
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
            PresenterManager.shared.show(vc: .ios)
        
          }
        
    }
    
    @IBAction func viewRankings(_ sender: UIButton) {
    }
    
    
    @IBAction func goBackHome(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .iosHome)
    }
    
    @IBAction func goMainPage(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .userHome)
        
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
