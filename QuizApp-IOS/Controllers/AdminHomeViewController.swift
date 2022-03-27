//
//  AdminHomeViewController.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import UIKit

class AdminHomeViewController: UITabBarController {

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }


    @IBAction func SignOut(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
}
