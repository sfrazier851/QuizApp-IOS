//
//  IOSViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class IOSViewController: UIViewController {

    @IBOutlet weak var ios_que_tv: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ans_1: UIButton!
    @IBOutlet weak var ans_2: UIButton!
    @IBOutlet weak var ans_3: UIButton!
    @IBOutlet weak var ans_4: UIButton!
    
    var qAsked = 0 //for questions answered by player
    
    var count = 0 //for total of questions
    
    var rand = -1
    
    var gamescore = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .userHome)
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
    }
    

}
