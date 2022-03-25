//
//  FeedbackViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/24/22.
//

import UIKit
import Speech

class FeedbackViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var btn_1: UIButton!
    
    @IBOutlet weak var btn_2: UIButton!
    
    @IBOutlet weak var btn_3: UIButton!
    
    @IBOutlet weak var btn_4: UIButton!
    
    @IBOutlet weak var btn_5: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var charLabel: UILabel!
    
    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var speechButton: UIButton!
    
    var btnArr : [UIButton]! = []
    
    let audioEng = AVAudioEngine()
    
    let speechR = SFSpeechRecognizer()
    
    let req = SFSpeechAudioBufferRecognitionRequest()
    
    var rTask : SFSpeechRecognitionTask!
    
    var isStart = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupBtnAlphas()
        Utilities.styleHollowButton(submitBtn)
        Utilities.styleHollowButton(backButton)
        Utilities.styleHollowButton(speechButton)
        feedbackTextView.delegate = self
        btnArr = [btn_1, btn_2, btn_3, btn_4, btn_5]
        
    }
  
    @IBAction func buttonsPressed(_ sender: UIButton) {
        
        var cnt = 1
        
        if sender.alpha == 1 && K.feedback_score == sender.tag {
            
            btnArr.forEach({
                
                $0.alpha = 0.3
                
            })
            
            
        } else {
        
            btnArr.forEach({
                
                if cnt <= sender.tag {
                    $0.alpha = 1
                } else {
                    $0.alpha = 0.3
                }
                
                cnt += 1
                
            })
            
            K.feedback_score = sender.tag
            
        }
        
    }
    
    @IBAction func submitFeedback(_ sender: UIButton) {
        
        var RM = ReviewModels(rate: K.feedback_score, comments: feedbackTextView.text!, idReviews: -1, User_ID: (LoginPort.user?.ID!)!)
        if DBCRUD.initDBCRUD.createReview(r: RM) == true {
            let dialogMessage = UIAlertController(title: "Alert", message: "Feedback Successfully Saved! Redirecting you to Home Page", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                PresenterManager.shared.show(vc: .userHome)
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            let dialogMessage = UIAlertController(title: "Alert", message: "Feedback Not Saved! Please try again later.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
          }
        
    }
    
    @IBAction func goBackToHome(_ sender: UIButton) {
    
        PresenterManager.shared.show(vc: .userHome)
    
    }
    
    
    func setupBtnAlphas() {
        
        btn_1.tag = 1
        btn_1.alpha = 0.3
        btn_2.tag = 2
        btn_2.alpha = 0.3
        btn_3.tag = 3
        btn_3.alpha = 0.3
        btn_4.tag = 4
        btn_4.alpha = 0.3
        btn_5.tag = 5
        btn_5.alpha = 0.3
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let charUsed = textView.text!.count
        charLabel.text = String(charUsed)+"/500"
        
        if charUsed > 500 {
            //print(feedbackTextView.text!.prefix(500))
            feedbackTextView.text = String(feedbackTextView.text!.prefix(500))
            charLabel.text = "500/500"
        }
        
    }
    
    @IBAction func startStopSpeechRecognition(_ sender: UIButton) {
        
        isStart = !isStart
        
        if isStart {
            startSpeechRec()
            sender.setTitle("Stop Speech Recognition", for: .normal)
        } else {
            cancelSpeechRec()
            sender.setTitle("Start Speech Recognition", for: .normal)
          }
        
        
    }
    
    func startSpeechRec() {
        
        let nd = audioEng.inputNode
        let recordF = nd.outputFormat(forBus: 0)
        
        nd.installTap(onBus: 0, bufferSize: 1024, format: recordF) {
            
            (buffer , _ ) in
            self.req.append(buffer)
        
        }
        
        audioEng.prepare()
        
        do {
            try audioEng.start()
        } catch let err {
            print("ERR1: \(err)")
          }
        
        rTask = speechR?.recognitionTask(with: req, resultHandler: { (resp , error) in
            
            guard let rsp = resp else {
                
                print("ERROR2: \(error.debugDescription)")
                return
            
            }
            
            let msg = resp?.bestTranscription.formattedString
            //print(msg)
            self.feedbackTextView.text = msg!
            self.textViewDidChange(self.feedbackTextView)

        })
    
    }
    
    func cancelSpeechRec() {
        
        rTask.finish()
        rTask.cancel()
        rTask = nil
        req.endAudio()
        audioEng.stop()
        
        if audioEng.inputNode.numberOfInputs > 0 {
            audioEng.inputNode.removeTap(onBus: 0)
        }
        
    }
    
}
