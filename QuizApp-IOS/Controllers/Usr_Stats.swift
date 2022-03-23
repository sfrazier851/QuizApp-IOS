//
//  Usr_Stats.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/23/22.
//

import UIKit

class Usr_Stats: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var Users: [String] = [String]()
    
    
    
    @IBOutlet weak var First_Place: UILabel!
    @IBOutlet weak var First_Place_Score: UILabel!
    
    @IBOutlet weak var Second_Place: UILabel!
    @IBOutlet weak var Second_Place_Score: UILabel!
    
    @IBOutlet weak var Third_Place: UILabel!
    @IBOutlet weak var Third_Place_Score: UILabel!
    
    @IBOutlet weak var Ban_Status: UISwitch!
    
    @IBOutlet weak var Available_Users: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Set Podium Based on Top 3 Overall User Scores */
        
        self.Available_Users.delegate = self
        self.Available_Users.dataSource = self
        
        // Users = Array of All Available Users
        // Ban_Status.setOn(false, animated: true)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Users.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return Users[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // Users[row] is the Selected User
        
        // Update TableView to show User Completed Quizes
        // Update Ban User Switch to Current Ban Status
    }
    
    @IBAction func Go_Back()
    {
        self.dismiss(animated: true);
    }
    
}
