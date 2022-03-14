//
//  LoadingViewController.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let userIsLoggedIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(durationInSeconds: 2.0) {
            self.showInitialView()
        }
    }
    
    private func showInitialView() {
        // if user is logged in => main tab bar controller
        // if user is NOT logged in => show onboarding controller
        if userIsLoggedIn {
            performSegue(withIdentifier: K.Segue.showInitial, sender: nil)
        } else {
            //performSegue(withIdentifier: , sender: nil)
        }
    }
}

