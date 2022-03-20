//
//  LoadingViewController.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let userIsLoggedIn = false
    
    @IBOutlet weak var tagline: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartbeat()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(durationInSeconds: 2.5) {
            self.showInitialView()
        }
    }
    
    private func showInitialView() {
        // if user is logged in => ?? controller
        // if user is NOT logged in => show login/signup controller
        if userIsLoggedIn {
            //performSegue(withIdentifier: , sender: nil)
        } else {
            PresenterManager.shared.show(vc: .initial)
        }
    }
    
    private func heartbeat() {
        
        // https://stackoverflow.com/questions/34729578/uibutton-heartbeat-animation -S.S.D
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.4
            pulse.fromValue = 1.0
            pulse.toValue = 1.12
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.initialVelocity = 0.5
            pulse.damping = 0.8
            tagline.layer.add(pulse, forKey: nil)
        
        
    }
    
    
}

