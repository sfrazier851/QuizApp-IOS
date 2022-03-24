//
//  AboutViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/24/22.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var goBackBtn: UIButton!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        Utilities.styleHollowButton(goBackBtn)
        
    }
    
    @IBAction func dismissModal(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }
    
}
