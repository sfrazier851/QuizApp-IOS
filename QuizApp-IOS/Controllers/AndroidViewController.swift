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
//    var qArr = [
//        ["Android Architecture is made up of the following components except:","Linux Kernel","Android Frameworks","Libraries","Cocoa Touch","Cocoa Touch"],
//        ["This is where you can find all the classes and methods that developers would need in order to write applications on the Android environment.","Libraries","Android Frameworks","Android Applications","Linux Kernel","Android Frameworks"],
//        ["This tool provides developers with the ability to deal with zip-compatible archives, which includes creating, extracting as well as viewing its contents.","Android Asset Packaging Tool","Asset Android Packaging Tool","Apple Archive Package Tool","Andro Asset Packaging Tool","Android Asset Packaging Tool"],
//        ["It is the first step towards the creation of a new Android project. It is made up of a shell script that will be used to create new file system structure necessary for writing codes within the Android IDE.","canvasCreator","projectCreator","activityCreator","libCreator","activityCreator"],
//        ["Activities are what you refer to as the window to a user interface.","True","False","","","True"],
//        ["All are essential states of an activity except:","Active","Paused","Destroyed","Inactive","Inactive"],
//        ["It allows developers the power to execute remote shell commands. Its basic function is to allow and control communication towards and from the emulator port.", "Android Debug Bridge","Apple Debug Bridge","Android Debug Box","Android Debugger Bridge","Android Debug Bridge"],
//        ["This is actually a dialog that appears to the user whenever an application have been unresponsive for a long period of time.","Application Not Responding","Agent Inactive Message","Window Blocker","State Not Active","Application Not Responding"],
//        ["The 'and' elements must be present and can occur as much as it's needed.","True","False","","","False"],
//        ["Andy Rubin originally founded Android under Android, Inc. in November 2003.","True","False","","","False"]
//    ]
    
    var qAsked = 0 //for questions answered by player
    
    var count = 0 //for total of questions
    
    var rand = -1
    
    var timer : Timer!
    
    var minTime = 30
    
    var secTime = 0
    
    var newTime : String = ""
    
    var rand_choices = 0
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        loadQuiz()
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
    var qArr = [[String]]()
    var Q1:QuizModels=DBCRUD.initDBCRUD.getQuizsFromTechnology_Title(id: "IOS")[0]
    func loadQuiz(){
        
        var Quiz:[[String]]=[[String]]()
        
        for Quest in Q1.Questions!{
        let Question:[String] =  [Quest.Question,Quest.choices![0],Quest.choices![1],Quest.choices![2],Quest.choices![3], Quest.Awnser]
            Quiz.append(Question)
        }
        self.qArr=Quiz
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

