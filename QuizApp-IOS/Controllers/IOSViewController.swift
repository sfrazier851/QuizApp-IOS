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
    @IBOutlet weak var timerImage: UIImageView!
    //    @IBOutlet weak var ans_1: UILabel!
//    @IBOutlet weak var ans_2: UILabel!
//    @IBOutlet weak var ans_3: UILabel!
//    @IBOutlet weak var ans_4: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
//    @IBOutlet weak var ans2_view: UIView!
//    @IBOutlet weak var ans1_view: UIView!
//    @IBOutlet weak var ans3_view: UIView!
//    @IBOutlet weak var ans4_view: UIView!
    
    @IBOutlet weak var ans_1: UIButton!
    @IBOutlet weak var ans_2: UIButton!
    @IBOutlet weak var ans_3: UIButton!
    @IBOutlet weak var ans_4: UIButton!
    
    var qArr = [
        ["What does IOS mean?","Internet Operation System","iPhone Operation System","Interval Operation System","iPhone Overriding System","iPhone Operation System"],
        ["It manages the appearance of the table.","UITableView","UIViewController","UICollectionView","UIImageView","UITableView"],
        ["It is the topmost layer in the iOS Architecture.","Core Services","Media Services","Cocoa Touch","Core OS","Cocoa Touch"],
        ["It is a connection or reference to the object created in the Interface Builder.","IBOutlet","IBAction","IBVariables","IBObject","IBOutlet"],
        ["A file that contains a key-value pair configuration of your application.","info.plist","dictionary","keychain","bundle identifier","info.plist"],
        ["It is a technology that allows transmission of data, voice and video through a computer or any portable device.","Mobile Programming", "Mobile Data","Mobile Computing","Mobile Phone","Mobile Computing"],
        ["For unwrapping value inside an Optional, what should be used?","!","!@","@","None Of Them","!"],
        ["What is the name of the deinitializer in the class declaration?","dealloc","release","deinit","finalize","deinit"],
        ["Which keyword do you use to define a protocol?", "protocol","@protocol","@interface","Protocol", "protocol"],
        ["Which keyword in the context of a Switch statement is required to force the execution of a subsequent case?","fallthrough","break","continue","throw","fallthrough"]
    ]
    
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

        // Do any additional setup after loading the view.
        progressBar.progress = 0.0
        count = qArr.count
        timerLabel.text = String(minTime)+":0"+String(secTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        K.ios_gamescore = 0
        showQuestionsForIOS()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        ios_que_tv.centerVertically()
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if (minTime >= 0 && secTime > 0 && qAsked != count) {
            timer.invalidate()
            let dialogMessage = UIAlertController(title: "Are You Sure?", message: "Leaving the game will lose your daily attempt and your chance for a new ranking. Do you still want to continue?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                PresenterManager.shared.show(vc: .iosHome)
            })
            let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            })
            dialogMessage.addAction(no)
            dialogMessage.addAction(yes)
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            PresenterManager.shared.show(vc: .iosHome)
          }
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        if sender.currentTitle! == qArr[rand][5] {
            //print(sender.currentTitle!)
            K.ios_gamescore += 1
        }
        
        qAsked += 1
        
        let perc = Float(qAsked) / Float(count)
        
        progressBar.progress = perc
        
        if perc == 1 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            //show
            
        } else {
            
            qArr.remove(at: rand)
            //print(qArr)
            showQuestionsForIOS()
            
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
            timerImage.image = UIImage(named: "redButton")
        }
        
        timerLabel.text = String(newTime)
        if minTime == 0 && secTime == 0 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            
        }
        
    }
    
    func showQuestionsForIOS() {
        
        rand = Int.random(in: 0...qArr.count - 1)
        //rand_choices = Int.random(in: 1...4)
        //print(rand)
        ios_que_tv.text = qArr[rand][0]
        var shuffled_choices : [Int] = []
        while shuffled_choices.count != 4 {
            rand_choices = Int.random(in: 1...4)
            if !shuffled_choices.contains(rand_choices) {
                //print(rand_choices)
                shuffled_choices.append(rand_choices)
            }
        }

        ans_1.setTitle(qArr[rand][shuffled_choices[0]], for: .normal)
        ans_2.setTitle(qArr[rand][shuffled_choices[1]], for: .normal)
        ans_3.setTitle(qArr[rand][shuffled_choices[2]], for: .normal)
        ans_4.setTitle(qArr[rand][shuffled_choices[3]], for: .normal)
        
    }
    
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
