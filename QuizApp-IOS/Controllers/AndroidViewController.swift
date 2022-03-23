//
//  AndroidViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class AndroidViewController: UIViewController {

    @IBOutlet weak var android_backButton: UIButton!
    @IBOutlet weak var android_timerImage: UIImageView!
    @IBOutlet weak var android_timerLabel: UILabel!
    @IBOutlet weak var android_que_tv: UITextView!
    @IBOutlet weak var android_progressBar: UIProgressView!
    @IBOutlet weak var android_ans_1: UIButton!
    @IBOutlet weak var android_ans_2: UIButton!
    @IBOutlet weak var android_ans_3: UIButton!
    @IBOutlet weak var android_ans_4: UIButton!
    
    @IBOutlet weak var android_que_tl: UILabel!
    
    var qAsked = 0 //for questions answered by player
    
    var count = 0 //for total of questions
    
    var rand = -1
    
    var timer : Timer!
    
    var minTime = 30
    
    var secTime = 0
    
    var newTime : String = ""
    
    var rand_choices = 0
    
    var qArr = [[String]]()
    
    var Q1 : QuizModels=DBCRUD.initDBCRUD.getQuizsFromTechnology_Title(id: "Android")[0]
    
    override func viewDidLoad() {

        super.viewDidLoad()
        qArr = Utilities.loadQuiz(Q : Q1)
        androidSetupElements()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //android_que_tv.centerVertically()
        
    }
    
    private func androidSetupElements() {
        
        android_progressBar.progress = 0.0
        count = qArr.count
        android_timerLabel.text = String(minTime)+":0"+String(secTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        K.android_gamescore = 0
        showQuestionsForAndroid()
        Utilities.styleHollowButton(android_backButton)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
    
        if (minTime >= 0 && secTime > 0 && qAsked != count) {
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
        
        if sender.currentTitle! == qArr[rand][5] {
            //print(sender.currentTitle!)
            K.android_gamescore += 1
        }
        
        qAsked += 1
        
        let perc = Float(qAsked) / Float(count)
        
        android_progressBar.progress = perc
        
        if perc == 1 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            //show
            
        } else {
            
            qArr.remove(at: rand)
            //print(qArr)
            showQuestionsForAndroid()
            
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
            //timerLabel.textColor = UIColor.red
            android_timerImage.image = UIImage(named: "redButton")
        }
        
        android_timerLabel.text = String(newTime)
        if minTime == 0 && secTime == 0 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            
        }
        
    }
    
    func showQuestionsForAndroid() {
        
        var found = false
        rand = Int.random(in: 0...qArr.count - 1)
        //rand_choices = Int.random(in: 1...4)
        //print(rand)
        android_que_tl.text = qArr[rand][0]
        var shuffled_choices : [Int] = []
        while shuffled_choices.count != 4 {
            rand_choices = Int.random(in: 1...4)
            if !shuffled_choices.contains(rand_choices) {
                //print(rand_choices)
                shuffled_choices.append(rand_choices)
            }
        }
        
        for sc in shuffled_choices {
            
            if qArr[rand][sc] == "" {
                found = true
                break
            }
            
        }
        
        if found {
         
            android_ans_1.isHidden = true
            android_ans_2.setTitle("True", for: .normal)
            android_ans_3.setTitle("False", for: .normal)
            android_ans_4.isHidden = true
            
        } else {

            android_ans_1.setTitle(qArr[rand][shuffled_choices[0]], for: .normal)
            android_ans_2.setTitle(qArr[rand][shuffled_choices[1]], for: .normal)
            android_ans_3.setTitle(qArr[rand][shuffled_choices[2]], for: .normal)
            android_ans_4.setTitle(qArr[rand][shuffled_choices[3]], for: .normal)
            android_ans_1.isHidden = false
            android_ans_4.isHidden = false
            
         }
        
    }
        
}

