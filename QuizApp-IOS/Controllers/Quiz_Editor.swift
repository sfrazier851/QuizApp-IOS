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
    
    @IBOutlet weak var Q11: UITextField!
    @IBOutlet weak var Q12: UITextField!
    @IBOutlet weak var Q13: UITextField!
    @IBOutlet weak var Q14: UITextField!
    @IBOutlet weak var Q15: UITextField!
    @IBOutlet weak var Q16: UITextField!
    @IBOutlet weak var Q17: UITextField!
    @IBOutlet weak var Q18: UITextField!
    @IBOutlet weak var Q19: UITextField!
    @IBOutlet weak var Q20: UITextField!
    
    @IBOutlet weak var Q21: UITextField!
    @IBOutlet weak var Q22: UITextField!
    @IBOutlet weak var Q23: UITextField!
    @IBOutlet weak var Q24: UITextField!
    @IBOutlet weak var Q25: UITextField!
    @IBOutlet weak var Q26: UITextField!
    @IBOutlet weak var Q27: UITextField!
    @IBOutlet weak var Q28: UITextField!
    @IBOutlet weak var Q29: UITextField!
    @IBOutlet weak var Q30: UITextField!
    
    @IBOutlet weak var Q31: UITextField!
    @IBOutlet weak var Q32: UITextField!
    @IBOutlet weak var Q33: UITextField!
    @IBOutlet weak var Q34: UITextField!
    @IBOutlet weak var Q35: UITextField!
    @IBOutlet weak var Q36: UITextField!
    @IBOutlet weak var Q37: UITextField!
    @IBOutlet weak var Q38: UITextField!
    @IBOutlet weak var Q39: UITextField!
    @IBOutlet weak var Q40: UITextField!
    
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
    
    @IBOutlet weak var Q11_C: UITextField!
    @IBOutlet weak var Q12_C: UITextField!
    @IBOutlet weak var Q13_C: UITextField!
    @IBOutlet weak var Q14_C: UITextField!
    @IBOutlet weak var Q15_C: UITextField!
    @IBOutlet weak var Q16_C: UITextField!
    @IBOutlet weak var Q17_C: UITextField!
    @IBOutlet weak var Q18_C: UITextField!
    @IBOutlet weak var Q19_C: UITextField!
    @IBOutlet weak var Q20_C: UITextField!
    
    @IBOutlet weak var Q21_C: UITextField!
    @IBOutlet weak var Q22_C: UITextField!
    @IBOutlet weak var Q23_C: UITextField!
    @IBOutlet weak var Q24_C: UITextField!
    @IBOutlet weak var Q25_C: UITextField!
    @IBOutlet weak var Q26_C: UITextField!
    @IBOutlet weak var Q27_C: UITextField!
    @IBOutlet weak var Q28_C: UITextField!
    @IBOutlet weak var Q29_C: UITextField!
    @IBOutlet weak var Q30_C: UITextField!
    
    @IBOutlet weak var Q31_C: UITextField!
    @IBOutlet weak var Q32_C: UITextField!
    @IBOutlet weak var Q33_C: UITextField!
    @IBOutlet weak var Q34_C: UITextField!
    @IBOutlet weak var Q35_C: UITextField!
    @IBOutlet weak var Q36_C: UITextField!
    @IBOutlet weak var Q37_C: UITextField!
    @IBOutlet weak var Q38_C: UITextField!
    @IBOutlet weak var Q39_C: UITextField!
    @IBOutlet weak var Q40_C: UITextField!
    
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
    
    @IBOutlet weak var Q11_W1: UITextField!
    @IBOutlet weak var Q12_W1: UITextField!
    @IBOutlet weak var Q13_W1: UITextField!
    @IBOutlet weak var Q14_W1: UITextField!
    @IBOutlet weak var Q15_W1: UITextField!
    @IBOutlet weak var Q16_W1: UITextField!
    @IBOutlet weak var Q17_W1: UITextField!
    @IBOutlet weak var Q18_W1: UITextField!
    @IBOutlet weak var Q19_W1: UITextField!
    @IBOutlet weak var Q20_W1: UITextField!
    @IBOutlet weak var Q11_W2: UITextField!
    @IBOutlet weak var Q12_W2: UITextField!
    @IBOutlet weak var Q13_W2: UITextField!
    @IBOutlet weak var Q14_W2: UITextField!
    @IBOutlet weak var Q15_W2: UITextField!
    @IBOutlet weak var Q16_W2: UITextField!
    @IBOutlet weak var Q17_W2: UITextField!
    @IBOutlet weak var Q18_W2: UITextField!
    @IBOutlet weak var Q19_W2: UITextField!
    @IBOutlet weak var Q20_W2: UITextField!
    @IBOutlet weak var Q11_W3: UITextField!
    @IBOutlet weak var Q12_W3: UITextField!
    @IBOutlet weak var Q13_W3: UITextField!
    @IBOutlet weak var Q14_W3: UITextField!
    @IBOutlet weak var Q15_W3: UITextField!
    @IBOutlet weak var Q16_W3: UITextField!
    @IBOutlet weak var Q17_W3: UITextField!
    @IBOutlet weak var Q18_W3: UITextField!
    @IBOutlet weak var Q19_W3: UITextField!
    @IBOutlet weak var Q20_W3: UITextField!
    
    @IBOutlet weak var Q21_W1: UITextField!
    @IBOutlet weak var Q22_W1: UITextField!
    @IBOutlet weak var Q23_W1: UITextField!
    @IBOutlet weak var Q24_W1: UITextField!
    @IBOutlet weak var Q25_W1: UITextField!
    @IBOutlet weak var Q26_W1: UITextField!
    @IBOutlet weak var Q27_W1: UITextField!
    @IBOutlet weak var Q28_W1: UITextField!
    @IBOutlet weak var Q29_W1: UITextField!
    @IBOutlet weak var Q30_W1: UITextField!
    @IBOutlet weak var Q21_W2: UITextField!
    @IBOutlet weak var Q22_W2: UITextField!
    @IBOutlet weak var Q23_W2: UITextField!
    @IBOutlet weak var Q24_W2: UITextField!
    @IBOutlet weak var Q25_W2: UITextField!
    @IBOutlet weak var Q26_W2: UITextField!
    @IBOutlet weak var Q27_W2: UITextField!
    @IBOutlet weak var Q28_W2: UITextField!
    @IBOutlet weak var Q29_W2: UITextField!
    @IBOutlet weak var Q30_W2: UITextField!
    @IBOutlet weak var Q21_W3: UITextField!
    @IBOutlet weak var Q22_W3: UITextField!
    @IBOutlet weak var Q23_W3: UITextField!
    @IBOutlet weak var Q24_W3: UITextField!
    @IBOutlet weak var Q25_W3: UITextField!
    @IBOutlet weak var Q26_W3: UITextField!
    @IBOutlet weak var Q27_W3: UITextField!
    @IBOutlet weak var Q28_W3: UITextField!
    @IBOutlet weak var Q29_W3: UITextField!
    @IBOutlet weak var Q30_W3: UITextField!
    
    @IBOutlet weak var Q31_W1: UITextField!
    @IBOutlet weak var Q32_W1: UITextField!
    @IBOutlet weak var Q33_W1: UITextField!
    @IBOutlet weak var Q34_W1: UITextField!
    @IBOutlet weak var Q35_W1: UITextField!
    @IBOutlet weak var Q36_W1: UITextField!
    @IBOutlet weak var Q37_W1: UITextField!
    @IBOutlet weak var Q38_W1: UITextField!
    @IBOutlet weak var Q39_W1: UITextField!
    @IBOutlet weak var Q40_W1: UITextField!
    @IBOutlet weak var Q31_W2: UITextField!
    @IBOutlet weak var Q32_W2: UITextField!
    @IBOutlet weak var Q33_W2: UITextField!
    @IBOutlet weak var Q34_W2: UITextField!
    @IBOutlet weak var Q35_W2: UITextField!
    @IBOutlet weak var Q36_W2: UITextField!
    @IBOutlet weak var Q37_W2: UITextField!
    @IBOutlet weak var Q38_W2: UITextField!
    @IBOutlet weak var Q39_W2: UITextField!
    @IBOutlet weak var Q40_W2: UITextField!
    @IBOutlet weak var Q31_W3: UITextField!
    @IBOutlet weak var Q32_W3: UITextField!
    @IBOutlet weak var Q33_W3: UITextField!
    @IBOutlet weak var Q34_W3: UITextField!
    @IBOutlet weak var Q35_W3: UITextField!
    @IBOutlet weak var Q36_W3: UITextField!
    @IBOutlet weak var Q37_W3: UITextField!
    @IBOutlet weak var Q38_W3: UITextField!
    @IBOutlet weak var Q39_W3: UITextField!
    @IBOutlet weak var Q40_W3: UITextField!
    
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
