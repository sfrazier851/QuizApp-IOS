//
//  IOSHomeViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/18/22.
//

import UIKit

class IOSHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .userHome)
        
    }
    
    @IBAction func startQuizPressed(_ sender: UIButton) {
        
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

}
