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
    
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(aboutButton)
        aboutButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        aboutButton.layer.borderWidth = 2
        aboutButton.layer.borderColor = K.Color.Blue.cgColor
        aboutButton.tintColor = .white
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(vc: .signUp)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        PresenterManager.shared.show(vc: .login)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AboutViewController") as! AboutViewController
        
        storyboard.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(storyboard, animated: true)

    }
    
}
