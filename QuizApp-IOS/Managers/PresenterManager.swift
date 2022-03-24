//
//  PresenterManager.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/17/22.
//

import UIKit

final class PresenterManager {
    
    static let shared = PresenterManager()
    
    private init() {}
    
    enum VC {
        case loading
        case initial
        case signUp
        case login
        case adminHome
        case userHome
        case iosHome
        case ios
        case java
        case android
        case gameOver
        case ranking
    }
    
    func show(vc: VC) {

        var viewController: UIViewController
        
        switch vc {
        
            case .loading:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.loadingViewController)
            
            case .initial:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.initialViewController)
            
            case .signUp:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.signUpViewController)
            
            case .login:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.loginViewController)
                
            case .adminHome:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.adminHomeViewController)
                
            case .userHome:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.userHomeViewController)
            
            case .iosHome:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.iosHomeViewController)
                
            case .ios:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.iosViewController)
            
            case .java:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.javaViewController)

            case .android:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.androidViewController)
            
            case .gameOver:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.gameOverViewController)
            
            case .ranking:
                viewController = UIStoryboard(name: K.StoryboardID.main, bundle: nil).instantiateViewController(identifier: K.StoryboardID.viewRankingViewController)
            
                    
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
                window.rootViewController = viewController
            
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

