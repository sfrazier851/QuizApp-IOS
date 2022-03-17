//
//  ViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/11/22.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        //Utilities.styleFilledButton(signUpButton)
        //Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(vc: .signUp)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(vc: .login)
    }
}

