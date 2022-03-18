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
    @IBOutlet weak var progressBar: UIProgressView!
    
    var qArr = [
        1:["What does IOS mean?","Internet Operation System","iPhone Operation System","Interval Operation System","iPhone Overriding System","iPhone Operation System"],
        2:["It manages the appearance of the table.","UITableView","UIViewController","UICollectionView","UIImageView","UITableView"],
        3:["It is the topmost layer in the iOS Architecture.","Core Services","Media Services","Cocoa Touch","Core OS","Cocoa Touch"]
    ]
    
    var qAsked = 0 //for questions answered by player
    
    var count = 0 //for total of questions
    
    var rand = -1
    
    var gamescore = 0
    
    var timer : Timer!
    
    var minTime = 2
    
    var secTime = 0
    
    var newTime : String = ""
    
    var rand_choices = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressBar.progress = 0.0
        timerLabel.text = String(minTime)+":0"+String(secTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        showQuestionsForIOS()
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if (minTime >= 0 && secTime > 0) {
            timer.invalidate()
            let dialogMessage = UIAlertController(title: "Are You Sure?", message: "Leaving the game will lose your daily attempt and your chance for a new ranking. Do you still want to continue?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                PresenterManager.shared.show(vc: .userHome)
            })
            let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            })
            dialogMessage.addAction(no)
            dialogMessage.addAction(yes)
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            PresenterManager.shared.show(vc: .userHome)
          }
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        if sender.currentTitle!.lowercased() == qArr[rand]![5].lowercased() {
            gamescore += 1
        }
        
        
    }
    
    @objc func updateTime() {
        
        newTime = ""
        
        if secTime == 0 {
            minTime -= 1
            secTime = 59
        } else {
                secTime -= 1
          }
        
        if minTime < 10 {
            newTime += "0"+String(minTime)
        } else {
            newTime += String(minTime)
           }
        
        newTime += ":"
        
        if secTime < 10 {
            newTime += "0"+String(secTime)
        } else {
            newTime += String(secTime)
          }
        
        if minTime < 5 {
            timerLabel.textColor = UIColor.red
        }
        
        timerLabel.text = String(newTime)
        if minTime == 0 && secTime == 0 {
            
            timer.invalidate()
            //print()
            
        }
        
    }
    
    func showQuestionsForIOS() {
        
        rand = Int.random(in: 0...qArr.count - 1)
        //rand_choices = Int.random(in: 1...4)
        ios_que_tv.text = qArr[rand]![0]
        var shuffled_choices : [Int] = []
        while shuffled_choices.count != 4 {
            rand_choices = Int.random(in: 1...4)
            if !shuffled_choices.contains(rand_choices) {
                shuffled_choices.append(rand_choices)
            }
        }

        ans_1.setTitle(qArr[rand]![shuffled_choices[0]], for: .normal)
        ans_2.setTitle(qArr[rand]![shuffled_choices[1]], for: .normal)
        ans_3.setTitle(qArr[rand]![shuffled_choices[2]], for: .normal)
        ans_4.setTitle(qArr[rand]![shuffled_choices[3]], for: .normal)
        
    }
    
}
