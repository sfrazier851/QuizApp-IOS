//
//  JavaViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit
import AVFoundation

class JavaViewController: UIViewController {
    
    @IBOutlet weak var java_backButton: UIButton!
    @IBOutlet weak var java_timerImage: UIImageView!
    @IBOutlet weak var java_timerLabel: UILabel!
    @IBOutlet weak var java_que_tv: UITextView!
    @IBOutlet weak var java_progressBar: UIProgressView!
    @IBOutlet weak var java_ans_1: UIButton!
    @IBOutlet weak var java_ans_2: UIButton!
    @IBOutlet weak var java_ans_3: UIButton!
    @IBOutlet weak var java_ans_4: UIButton!

    var qArr = [
        ["It is a subsystem in Java Virtual Machine dedicated to loading class files when a program is executed.","classLoader","bootstrapLoader","applet","java kit","classLoader"],
        ["It is called when an instance of the object is created, and memory is allocated for the object.","Method","Constructor","Class","Object","Constructor"],
        ["The founder and lead designer behind the Java Programming Language.","James Gosling","Alan Turing","Larry Ellison","Dennis Ritchie","James Gosling"],
        ["It is a technique in Java of having more than one constructor with different parameter lists.","Constructor Overloading","Constructor Overriding","Method Overloading","Method Overriding","Constructor Overloading"],
        ["It is a mechanism in which one object acquires all the properties and behaviors of a parent object.","Inheritance","Encapsulation","Polymorphism","Abstraction","Inheritance"],
        ["It is the ability of an object to take on many forms.", "Inheritance","Encapsulation","Polymorphism","Abstraction","Polymorphism"],
        ["It is a process of wrapping code and data together into a single unit.","Inheritance","Encapsulation","Polymorphism","Abstraction","Encapsulation"],
        ["It is a process of hiding the implementation details and showing only functionality to the user.","Inheritance","Encapsulation","Polymorphism","Abstraction","Abstraction"],
        ["It is a template or blueprint from which objects are created.","Class","Constructor","Struct","Enum","Class"],
        ["It is a class which inherits the other class. It is also called a derived class, extended class, or child class.","Sub Class","Super Class","Function","Protocol","Sub Class"],
        ["It is the class from where a subclass inherits the features. It is also called a base class or a parent class.", "Method","Abstraction","Object","Super Class","Super Class"],
        ["It indicates that you are making a new class that derives from an existing class.", "extends", "let","birthed","reached","extends"],
        ["All are types of Inheritance except:","Single Inheritance","Multi-Level Inheritance","Hierarchical Inheritance","Heirarchical Inheritance","Heirarchical Inheritance"],
        ["All are advantages of Encapsulation except:","Not Accessible","Control Over Data","Data Hiding","Easy To Test","Not Accessible"],
        ["It specifies accessibility (scope) of a data member, method, constructor or class.","Access Modifiers","Struct","Constants","Class","Access Modifiers"]
    ]
    
    var qAsked = 0 //for questions answered by player
    
    var count = 0 //for total of questions
    
    var rand = -1
    
    var timer : Timer!
    
    var minTime = 30
    
    var secTime = 0
    
    var newTime : String = ""
    
    var rand_choices = 0
    
    var player : AVAudioPlayer!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        java_progressBar.progress = 0.0
        count = qArr.count
        java_timerLabel.text = String(minTime)+":0"+String(secTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        K.java_gamescore = 0
        showQuestionsForJava()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        java_que_tv.centerVertically()
        
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
            K.java_gamescore += 1
            //playSound(soundName: "correct-answer", exte: "mp3")
        }
//        } else {
//            playSound(soundName: "wrong-answer", exte: "wav")
//          }
        
        qAsked += 1
        
        let perc = Float(qAsked) / Float(count)
        
        java_progressBar.progress = perc
        
        if perc == 1 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            //show
            
        } else {
            
            qArr.remove(at: rand)
            //print(qArr)
            showQuestionsForJava()
            
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
            java_timerImage.image = UIImage(named: "redButton")
        }
        
        java_timerLabel.text = String(newTime)
        if minTime == 0 && secTime == 0 {
            
            timer.invalidate()
            PresenterManager.shared.show(vc: .gameOver)
            
        }
        
    }
    
    func showQuestionsForJava() {
        
        rand = Int.random(in: 0...qArr.count - 1)
        //rand_choices = Int.random(in: 1...4)
        //print(rand)
        java_que_tv.text = qArr[rand][0]
        var shuffled_choices : [Int] = []
        while shuffled_choices.count != 4 {
            rand_choices = Int.random(in: 1...4)
            if !shuffled_choices.contains(rand_choices) {
                //print(rand_choices)
                shuffled_choices.append(rand_choices)
            }
        }

        java_ans_1.setTitle(qArr[rand][shuffled_choices[0]], for: .normal)
        java_ans_2.setTitle(qArr[rand][shuffled_choices[1]], for: .normal)
        java_ans_3.setTitle(qArr[rand][shuffled_choices[2]], for: .normal)
        java_ans_4.setTitle(qArr[rand][shuffled_choices[3]], for: .normal)
        
    }
    
    func playSound(soundName : String, exte : String) { //parameter : DataType
        
        let url = Bundle.main.url(forResource: soundName, withExtension: exte)
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()

    }
        
}
