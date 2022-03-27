//
//  ManageTestsViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/27/22.
//

import UIKit

class ManageTestsViewController: UIViewController {

    
    @IBOutlet weak var makeAQuiz: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var editQuizBtn: UIButton!
    
    @IBOutlet weak var deleteQuizBtn: UIButton!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        Utilities.styleHollowButton(makeAQuiz)
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleHollowButton(editQuizBtn)
        Utilities.styleHollowButton(deleteQuizBtn)
        editQuizBtn.isHidden = true
        deleteQuizBtn.isHidden = true

    }
 
    @IBAction func createAQuiz(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .testMaker)
        
    }
    
}
