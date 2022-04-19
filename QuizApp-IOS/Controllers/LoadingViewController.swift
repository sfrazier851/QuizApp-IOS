//
//  LoadingViewController.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var tagline: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartbeat()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // wait for animation to run for a bit
        delay(durationInSeconds: 1.3) {
            // get access token from keychain (or nil colesce to empty Data()/byte buffer)
            if let storedToken = String(data: KeychainManager.read(service: K.Keychain.Facebook.service, account: K.Keychain.Facebook.account) ?? Data(), encoding: .utf8) {
                // if access token is "" skip token verification
                if storedToken.isEmpty { PresenterManager.shared.show(vc: .initial)}
                // verify access token via facebook api
                Utilities.checkTokenValidity(storedToken)
            }
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

