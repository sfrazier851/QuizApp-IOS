//
//  AdminUserDetails.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import UIKit

class AdminUserDetails: UIViewController {

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var Biography: UILabel!
    @IBOutlet weak var Medal: UILabel!
    
    
    var chibi: Chirabi?
    {
        didSet
        {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func refreshUI()
    {
        loadViewIfNeeded()
        UserName.text = chibi?.name
        Biography.text = chibi?.bio
        
        var At: String
        
        switch(chibi?.Art)
        {
        case .Aura:
            At = "Aura"
        case .Cataclysm:
            At = "Cataclysm"
        case .Celestial:
            At = "Celestial"
        case .Chaos:
            At = "Chaos"
        case .Elem:
            At = "Elem"
        case .Emotion:
            At = "Emotion"
        case .Force:
            At = "Force"
        case .Hyper:
            At = "Hyper"
        case .Ragnarok:
            At = "Ragnarok"
        case .Weapon:
            At = "Weapon"
        default:
            At = "Unknown"
        }
        
        Medal.text = At
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AdminUserDetails: ChibiSelectionDelegate
{
    func ChibiSelected(_ NextChibi: Chirabi)
    {
        chibi = NextChibi
    }
}
