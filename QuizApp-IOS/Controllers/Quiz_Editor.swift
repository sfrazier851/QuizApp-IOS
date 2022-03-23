//
//  Quiz_Editor.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/21/22.
//

import UIKit

class Quiz_Editor: UIViewController {

    // Question Slots
    @IBOutlet weak var Q1: UITextField!
    @IBOutlet weak var Q2: UITextField!
    @IBOutlet weak var Q3: UITextField!
    @IBOutlet weak var Q4: UITextField!
    @IBOutlet weak var Q5: UITextField!
    @IBOutlet weak var Q6: UITextField!
    @IBOutlet weak var Q7: UITextField!
    @IBOutlet weak var Q8: UITextField!
    @IBOutlet weak var Q9: UITextField!
    @IBOutlet weak var Q10: UITextField!
    
    // Correct Answers
    @IBOutlet weak var Q1_C: UITextField!
    @IBOutlet weak var Q2_C: UITextField!
    @IBOutlet weak var Q3_C: UITextField!
    @IBOutlet weak var Q4_C: UITextField!
    @IBOutlet weak var Q5_C: UITextField!
    @IBOutlet weak var Q6_C: UITextField!
    @IBOutlet weak var Q7_C: UITextField!
    @IBOutlet weak var Q8_C: UITextField!
    @IBOutlet weak var Q9_C: UITextField!
    @IBOutlet weak var Q10_C: UITextField!
    
    // Wrong Answers
    @IBOutlet weak var Q1_W1: UITextField!
    @IBOutlet weak var Q2_W1: UITextField!
    @IBOutlet weak var Q3_W1: UITextField!
    @IBOutlet weak var Q4_W1: UITextField!
    @IBOutlet weak var Q5_W1: UITextField!
    @IBOutlet weak var Q6_W1: UITextField!
    @IBOutlet weak var Q7_W1: UITextField!
    @IBOutlet weak var Q8_W1: UITextField!
    @IBOutlet weak var Q9_W1: UITextField!
    @IBOutlet weak var Q10_W1: UITextField!
    @IBOutlet weak var Q1_W2: UITextField!
    @IBOutlet weak var Q2_W2: UITextField!
    @IBOutlet weak var Q3_W2: UITextField!
    @IBOutlet weak var Q4_W2: UITextField!
    @IBOutlet weak var Q5_W2: UITextField!
    @IBOutlet weak var Q6_W2: UITextField!
    @IBOutlet weak var Q7_W2: UITextField!
    @IBOutlet weak var Q8_W2: UITextField!
    @IBOutlet weak var Q9_W2: UITextField!
    @IBOutlet weak var Q10_W2: UITextField!
    @IBOutlet weak var Q1_W3: UITextField!
    @IBOutlet weak var Q2_W3: UITextField!
    @IBOutlet weak var Q3_W3: UITextField!
    @IBOutlet weak var Q4_W3: UITextField!
    @IBOutlet weak var Q5_W3: UITextField!
    @IBOutlet weak var Q6_W3: UITextField!
    @IBOutlet weak var Q7_W3: UITextField!
    @IBOutlet weak var Q8_W3: UITextField!
    @IBOutlet weak var Q9_W3: UITextField!
    @IBOutlet weak var Q10_W3: UITextField!
    
    @IBOutlet weak var Scroll: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func Save_as_Java(_ sender: Any) {
        
    }
    
    @IBAction func Save_as_IOS(_ sender: Any) {
        
    }
    
    @IBAction func Save_as_Android(_ sender: Any) {
        
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true);
    }
    
}
