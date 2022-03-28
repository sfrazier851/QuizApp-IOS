//
//  AdminTestMaker.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import UIKit

class AdminTestMaker: UIViewController {

    @IBOutlet weak var QuizTitle: UITextField!
    
    @IBOutlet weak var Question1: UITextField!
    @IBOutlet weak var CorrectAnswer1: UITextField!
    @IBOutlet weak var WrongAnswer1A: UITextField!
    @IBOutlet weak var WrongAnswer1B: UITextField!
    @IBOutlet weak var WrongAnswer1C: UITextField!
    
    @IBOutlet weak var Question2: UITextField!
    @IBOutlet weak var CorrectAnswer2: UITextField!
    @IBOutlet weak var WrongAnswer2A: UITextField!
    @IBOutlet weak var WrongAnswer2B: UITextField!
    @IBOutlet weak var WrongAnswer2C: UITextField!
    
    @IBOutlet weak var Question3: UITextField!
    @IBOutlet weak var CorrectAnswer3: UITextField!
    @IBOutlet weak var WrongAnswer3A: UITextField!
    @IBOutlet weak var WrongAnswer3B: UITextField!
    @IBOutlet weak var WrongAnswer3C: UITextField!
    
    @IBOutlet weak var Question4: UITextField!
    @IBOutlet weak var CorrectAnswer4: UITextField!
    @IBOutlet weak var WrongAnswer4A: UITextField!
    @IBOutlet weak var WrongAnswer4B: UITextField!
    @IBOutlet weak var WrongAnswer4C: UITextField!
    
    @IBOutlet weak var Question5: UITextField!
    @IBOutlet weak var CorrectAnswer5: UITextField!
    @IBOutlet weak var WrongAnswer5A: UITextField!
    @IBOutlet weak var WrongAnswer5B: UITextField!
    @IBOutlet weak var WrongAnswer5C: UITextField!
    
    @IBOutlet weak var cancelAdminButton: UIButton!

    @IBOutlet weak var saveAs: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Utilities.styleHollowButton(cancelAdminButton)
        //saveAs.centerVertically()
        //saveAs.text = "SAVE\nAS:"
        
    }
    
    
    @IBAction func Cancel(_ sender: Any)
    {
        PresenterManager.shared.show(vc: .adminHome)
    }
    
    func addQuizToNotifications(quizType: String) {
        //  ADD THE NEXT LINES OF CODE TO ADMIN "on create quiz button tapped function" and adjust the next to last line for the specific type of quiz created
        // get user default values for app icon badge count
        var appIconBadgeCount = UserDefaults.standard.integer(forKey: K.UserDefaults.appIconBadgeCount)
        // get dictionary for ["Java":0,"iOS":0,"Android":0] from user defaults (values might not be 0)
        var latestNewQuizTypesAndCount = UserDefaults.standard.object(forKey: K.UserDefaults.latestNewQuizAndTypesCount) as! [String:Int]
        // 1 total new quizzes were created (example)
        appIconBadgeCount += 1
        UserDefaults.standard.set(appIconBadgeCount, forKey: K.UserDefaults.appIconBadgeCount)
        // update technology type count (example)
        latestNewQuizTypesAndCount[quizType]! += 1
        UserDefaults.standard.set(latestNewQuizTypesAndCount, forKey: K.UserDefaults.latestNewQuizAndTypesCount)
        //----------------------------------------------------------
        
    }
    
    @IBAction func SaveToIOS(_ sender: Any) {

        let Quiz = QuizModels(Title: QuizTitle.text!, Technology_Title: "IOS")
        
        var wrong_choices: Array<String> = [WrongAnswer1A.text!, WrongAnswer1B.text!, WrongAnswer1C.text!,CorrectAnswer1.text!]
        let Question1 = QuestionModels(Question: self.Question1.text!, Awnser: CorrectAnswer1.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer2A.text!, WrongAnswer2B.text!, WrongAnswer2C.text!,CorrectAnswer2.text!]
        let Question2 = QuestionModels(Question: self.Question2.text!, Awnser: CorrectAnswer2.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer3A.text!, WrongAnswer3B.text!, WrongAnswer3C.text!,CorrectAnswer3.text!]
        let Question3 = QuestionModels(Question: self.Question3.text!, Awnser: CorrectAnswer3.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer4A.text!, WrongAnswer4B.text!, WrongAnswer4C.text!,CorrectAnswer4.text!]
        let Question4 = QuestionModels(Question: self.Question4.text!, Awnser: CorrectAnswer4.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer5A.text!, WrongAnswer5B.text!, WrongAnswer5C.text!,CorrectAnswer5.text!]
        let Question5 = QuestionModels(Question: self.Question5.text!, Awnser: CorrectAnswer5.text!, choice: wrong_choices)
        
        Quiz.Questions = [Question1, Question2, Question3, Question4, Question5 ]
        Quiz.save()
        
        let dialogMessage = UIAlertController(title: "Confirmation", message: "Quiz (\(QuizTitle.text!)) has been saved. Would you like to continue adding?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default, handler: { [self] (action) -> Void in
            addQuizToNotifications(quizType: "iOS")
            PresenterManager.shared.show(vc: .adminHome)
        })
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) -> Void in
            addQuizToNotifications(quizType: "iOS")
            self.resetFields()
        })
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveToAndroid(_ sender: Any){
        
        let Quiz = QuizModels(Title: QuizTitle.text!, Technology_Title: "Android")
        
        var wrong_choices: Array<String> = [WrongAnswer1A.text!, WrongAnswer1B.text!, WrongAnswer1C.text!,CorrectAnswer1.text!]
        let Question1 = QuestionModels(Question: self.Question1.text!, Awnser: CorrectAnswer1.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer2A.text!, WrongAnswer2B.text!, WrongAnswer2C.text!,CorrectAnswer2.text!]
        let Question2 = QuestionModels(Question: self.Question2.text!, Awnser: CorrectAnswer2.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer3A.text!, WrongAnswer3B.text!, WrongAnswer3C.text!, CorrectAnswer3.text!]
        let Question3 = QuestionModels(Question: self.Question3.text!, Awnser: CorrectAnswer3.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer4A.text!, WrongAnswer4B.text!, WrongAnswer4C.text!,CorrectAnswer4.text!]
        let Question4 = QuestionModels(Question: self.Question4.text!, Awnser: CorrectAnswer4.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer5A.text!, WrongAnswer5B.text!, WrongAnswer5C.text!,CorrectAnswer5.text!]
        let Question5 = QuestionModels(Question: self.Question5.text!, Awnser: CorrectAnswer5.text!, choice: wrong_choices)
        
        Quiz.Questions = [Question1, Question2, Question3, Question4, Question5 ]
        Quiz.save()
        
        let dialogMessage = UIAlertController(title: "Confirmation", message: "Quiz (\(QuizTitle.text!)) has been saved. Would you like to continue adding?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default, handler: { [self] (action) -> Void in
            self.addQuizToNotifications(quizType: "Android")
            PresenterManager.shared.show(vc: .adminHome)
        })
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) -> Void in
            self.addQuizToNotifications(quizType: "Android")
            self.resetFields()
        })
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveToJava(_ sender: Any){
        
        let Quiz = QuizModels(Title: QuizTitle.text!, Technology_Title: "Java")
        
        var wrong_choices: Array<String> = [WrongAnswer1A.text!, WrongAnswer1B.text!, WrongAnswer1C.text!,CorrectAnswer1.text!]
        let Question1 = QuestionModels(Question: self.Question1.text!, Awnser: CorrectAnswer1.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer2A.text!, WrongAnswer2B.text!, WrongAnswer2C.text!,CorrectAnswer2.text!]
        let Question2 = QuestionModels(Question: self.Question2.text!, Awnser: CorrectAnswer2.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer3A.text!, WrongAnswer3B.text!, WrongAnswer3C.text!,CorrectAnswer3.text!]
        let Question3 = QuestionModels(Question: self.Question3.text!, Awnser: CorrectAnswer3.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer4A.text!, WrongAnswer4B.text!, WrongAnswer4C.text!,CorrectAnswer4.text!]
        let Question4 = QuestionModels(Question: self.Question4.text!, Awnser: CorrectAnswer4.text!, choice: wrong_choices)
        
        wrong_choices = [WrongAnswer5A.text!, WrongAnswer5B.text!, WrongAnswer5C.text!,CorrectAnswer5.text!]
        let Question5 = QuestionModels(Question: self.Question5.text!, Awnser: CorrectAnswer5.text!, choice: wrong_choices)
        
        Quiz.Questions = [Question1, Question2, Question3, Question4, Question5 ]
        Quiz.save()
        
        let dialogMessage = UIAlertController(title: "Confirmation", message: "Quiz (\(QuizTitle.text!)) has been saved. Would you like to continue adding?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            self.addQuizToNotifications(quizType: "Java")
            PresenterManager.shared.show(vc: .adminHome)
        })
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.addQuizToNotifications(quizType: "Java")
            self.resetFields()
        })
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }

    func resetFields() {
        
        QuizTitle.text = ""
        
        Question1.text = ""
        WrongAnswer1A.text = ""
        WrongAnswer1B.text = ""
        WrongAnswer1C.text = ""
        CorrectAnswer1.text = ""

        Question2.text = ""
        WrongAnswer2A.text = ""
        WrongAnswer2B.text = ""
        WrongAnswer2C.text = ""
        CorrectAnswer2.text = ""
        
        Question3.text = ""
        WrongAnswer3A.text = ""
        WrongAnswer3B.text = ""
        WrongAnswer3C.text = ""
        CorrectAnswer3.text = ""
        
        Question4.text = ""
        WrongAnswer4A.text = ""
        WrongAnswer4B.text = ""
        WrongAnswer4C.text = ""
        CorrectAnswer4.text = ""
        
        Question5.text = ""
        WrongAnswer5A.text = ""
        WrongAnswer5B.text = ""
        WrongAnswer5C.text = ""
        CorrectAnswer5.text = ""
        
    }
    
    
}
