//
//  ViewRankingViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/22/22.
//

import UIKit

class ViewRankingViewController: UIViewController {

    @IBOutlet weak var vrTimerLabel: UILabel!
    
    @IBOutlet weak var vrTableView: UITableView!
  
    @IBOutlet weak var backButton: UIButton!
    
    var timer : Timer!
    
    var SM = [ScoreBoardModels]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadUserRankings()
        setupViewRankingUI()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    
    }
    
    func setupViewRankingUI() {
        
        vrTableView.dataSource = self
        vrTableView.delegate = self
        vrTableView.register(UINib(nibName: "ViewRankingTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewRankingTableViewCell")
        //vrTimerLabel.isHidden = true
        Utilities.styleHollowButton(backButton)
        vrTableView.backgroundColor = UIColor.clear
        
    }

    @IBAction func goBack(_ sender: UIButton) {
        
        timer.invalidate()
        //self.dismiss(animated: true, completion: nil)
        PresenterManager.shared.show(vc: .gameOver)
        
    }
    
    @objc func updateTimeLabel() {
        
        
        //https://www.codingem.com/swift-time-difference-between-date-objects/
        
        let now = Date()
        let midnight = Calendar.current.nextDate(after: now, matching: DateComponents(hour:0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd HH mm ss"
        let day1 = formatter.date(from: formatter.string(from: now))
        let day2 = formatter.date(from: formatter.string(from: midnight))
        
        let diffSeconds = day2!.timeIntervalSinceReferenceDate - day1!.timeIntervalSinceReferenceDate
        //print(diffSeconds)
        let (h,m,s) = secondsToHoursMinutesSeconds(Int(diffSeconds))
        var newtime = "New Daily Ranking will be updated in\n"
        
        if h < 10 {
            newtime += "0"+String(h) + ":"
        } else {
            newtime += String(h) + ":"
          }
        
        if m < 10 {
            newtime += "0"+String(m) + ":"
        } else {
            newtime += String(m) + ":"
          }
        
        if s < 10 {
            newtime += "0"+String(s)
        } else {
            newtime += String(s)
          }
        
        vrTimerLabel.text = newtime
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
    
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    
    }
    
    func loadUserRankings() {
        
        let day:String = Utilities.formatDate(date: Date())
//        let userSub = DBCRUD.initDBCRUD.UserIDToUser(id: (LoginPort.user?.ID)!)
//        if userSub.Subscript == 1 {
//
//        } else {
            SM = DBCRUD.initDBCRUD.getTacRankDay(Technology_Title: K.currentPage, Date: day, Limit: 10)
          }
        //print("\n\n\n\n\n\(SM.count)")
//    }
    
}

extension ViewRankingViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return SM.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewRankingTableViewCell") as! ViewRankingTableViewCell
        
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

extension ViewRankingViewController : UITableViewDelegate {
    
    
    
}
