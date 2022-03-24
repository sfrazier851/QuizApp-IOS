//
//  ViewRankingByTechViewController.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/24/22.
//

import UIKit

class ViewRankingByTechViewController: UIViewController {

    @IBOutlet weak var allRankingButton: UIButton!
    @IBOutlet weak var javaRankingButton: UIButton!
    @IBOutlet weak var iosRankingButton: UIButton!
    @IBOutlet weak var androidRankingButton: UIButton!
    @IBOutlet weak var vrtbLabel: UILabel!
    @IBOutlet weak var vrtbTableView: UITableView!
    @IBOutlet weak var vrbtBackButton: UIButton!
    var timer : Timer!
    var SM = [ScoreBoardModels]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadUserRankings(page : "")
        setupUIElements()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        
    }
    
    func setupUIElements() {
        
        allRankingButton.tag = 0
        javaRankingButton.tag = 1
        iosRankingButton.tag = 2
        androidRankingButton.tag = 3
        Utilities.styleHollowButton(vrbtBackButton)
        vrtbTableView.dataSource = self
        vrtbTableView.delegate = self
        vrtbTableView.register(UINib(nibName: "ViewRankingByTechTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewRankingByTechTableViewCell")
        //vrTimerLabel.isHidden = true
        vrtbTableView.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func showRanking(_ sender: UIButton) {
        
        //print("BUTTON: \(sender.tag)")
        
        allRankingButton.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        javaRankingButton.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        iosRankingButton.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        androidRankingButton.setBackgroundImage(UIImage(named: "greyButton"), for: .normal)
        
        var page : String
        
        switch sender.tag {
            
            case 1:
                page = "Java"
                javaRankingButton.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            case 2:
                page = "IOS"
                iosRankingButton.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            case 3:
                page = "Android"
                androidRankingButton.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            default:
                page = ""
                allRankingButton.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
            
        }
        
        loadUserRankings(page : page)
        self.vrtbTableView.reloadData()
        //self.refresher.endRefreshing()
        
    }
    
    @IBAction func goBackHome(_ sender: UIButton) {
        
        timer.invalidate()
        PresenterManager.shared.show(vc: .userHome)
        
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
        
        //print("TIME: "+newtime)
        vrtbLabel.text = newtime
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
    
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    
    }
    
    func loadUserRankings(page : String) {
        
        let day:String = Utilities.formatDate(date: Date())
        SM = DBCRUD.initDBCRUD.getTacRankDay(Technology_Title: page, Date: day)

    }
}

extension ViewRankingByTechViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SM.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewRankingByTechTableViewCell") as! ViewRankingByTechTableViewCell
        
        //when being reloaded
        cell.position.textColor = UIColor.white
        cell.username.textColor = UIColor.white
        cell.score.textColor = UIColor.white
        
        switch indexPath.row {
            
            case 0:
                cell.position.textColor = UIColor.cyan
                cell.username.textColor = UIColor.cyan
                cell.score.textColor = UIColor.cyan
                
            case 1:
                cell.position.textColor = UIColor.green
                cell.username.textColor = UIColor.green
                cell.score.textColor = UIColor.green
            case 2:
                cell.position.textColor = UIColor.systemPink
                cell.username.textColor = UIColor.systemPink
                cell.score.textColor = UIColor.systemPink
            default:
                print("color black")
            
        }

        cell.position.text = String(indexPath.row + 1)
        let uname = DBCRUD.initDBCRUD.UserIDToUser(id: SM[indexPath.row].User_ID)
        cell.username.text = uname.UserName
        cell.score.text = String(SM[indexPath.row].Score)
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    
    
}

extension ViewRankingByTechViewController : UITableViewDelegate {
    
    
}
