//
//  PrizesViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/28/22.
//

import UIKit

class PrizesViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var awardButton: UIButton!
    
    @IBOutlet weak var prizesTableView: UITableView!
    
    @IBOutlet weak var javaBtn: UIButton!
    
    @IBOutlet weak var iosBtn: UIButton!
    
    @IBOutlet weak var androidBtn: UIButton!
    
    var SM = [ScoreBoardModels]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadUserRankings(page: "Java")
        setupPrizesUI()

    }
    
    func setupPrizesUI() {
        
        javaBtn.tag = 0
        iosBtn.tag = 1
        androidBtn.tag = 2
        prizesTableView.dataSource = self
        prizesTableView.delegate = self
        prizesTableView.register(UINib(nibName: "PrizesTableViewCell", bundle: nil), forCellReuseIdentifier: "PrizesTableViewCell")
        Utilities.styleHollowButton(backButton)
        prizesTableView.backgroundColor = UIColor.clear
        Utilities.styleHollowButton(backButton)
        Utilities.styleHollowButton(awardButton)
        
    }
    
    @IBAction func loadCurrentWinners(_ sender: UIButton) {
        
        javaBtn.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        iosBtn.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        androidBtn.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        
        var page : String
        
        switch sender.tag {
            
            case 1:
                page = "IOS"
                iosBtn.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            case 2:
                page = "Android"
                androidBtn.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            default:
                page = "Java"
                javaBtn.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            
        }
        
        loadUserRankings(page : page)
        self.prizesTableView.reloadData()
    }
    
    func loadUserRankings(page : String) {
        
        let day:String = Utilities.formatDate(date: Date())
        SM = DBCRUD.initDBCRUD.getTacRankDay(Technology_Title: page, Date: day, Limit: 3)
    
    }
    
    @IBAction func backButton(_ sender: UIButton) {
    
        PresenterManager.shared.show(vc: .adminHome)
        
    }
    

}

extension PrizesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SM.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizesTableViewCell") as! PrizesTableViewCell
        
        switch indexPath.row {
            
            case 0:
                cell.position.textColor = UIColor.cyan
                cell.userName.textColor = UIColor.cyan
                cell.score.textColor = UIColor.cyan
                
            case 1:
                cell.position.textColor = UIColor.green
                cell.userName.textColor = UIColor.green
                cell.score.textColor = UIColor.green
            case 2:
                cell.position.textColor = UIColor.systemPink
                cell.userName.textColor = UIColor.systemPink
                cell.score.textColor = UIColor.systemPink
            default:
                print("color black")
            
        }

        cell.position.text = String(indexPath.row + 1)
        let uname = DBCRUD.initDBCRUD.UserIDToUser(id: SM[indexPath.row].User_ID)
        cell.userName.text = uname.UserName
        cell.score.text = String(SM[indexPath.row].Score)
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    
    
    
    
}

extension PrizesViewController : UITableViewDelegate {
    

}
