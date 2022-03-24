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
        
//        secondVC.modalPresentationStyle =
//        secondVC.modalTransitionStyle = .crossDissolve
        
//        present(secondVC, animated: true, completion: nil)
//        
//        let popOverVC = UIStoryboard(name: "SpinningWheel", bundle: nil).instantiateViewController(withIdentifier: "PhotoPopUp") as! PopUpViewController
//            popOverVc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            tabBarController.present(popOverVC, animated: true)
    }
    
}
