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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        vrTableView.dataSource = self
        vrTableView.delegate = self
        vrTableView.register(UINib(nibName: "ViewRankingTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewRankingTableViewCell")
        //vrTimerLabel.isHidden = true
        Utilities.styleHollowButton(backButton)
        vrTableView.backgroundColor = UIColor.clear
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    
    }

    @IBAction func goBack(_ sender: UIButton) {
        
        print("go back")
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
    
}

extension ViewRankingViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewRankingTableViewCell") as! ViewRankingTableViewCell
        
        switch indexPath.row {
            
            case 0:
                cell.position.textColor = UIColor.cyan
                cell.userName.textColor = UIColor.cyan
                cell.score.textColor = UIColor.cyan
                cell.position.text = String(indexPath.row + 1)
                cell.userName.text = String(describing: UserSessionManager.getUserScreenName())
                cell.score.text = "1290"
            case 1:
                cell.position.textColor = UIColor.green
                cell.userName.textColor = UIColor.green
                cell.score.textColor = UIColor.green
                cell.position.text = String(indexPath.row + 1)
                cell.userName.text = String(describing: UserSessionManager.getUserScreenName())
                cell.score.text = "1290"
            case 2:
                cell.position.textColor = UIColor.systemPink
                cell.userName.textColor = UIColor.systemPink
                cell.score.textColor = UIColor.systemPink
                cell.position.text = String(indexPath.row + 1)
                cell.userName.text = String(describing: UserSessionManager.getUserScreenName())
                cell.score.text = "1290"
            default:
                print("color black")
                cell.position.text = String(indexPath.row + 1)
                cell.userName.text = String(describing: UserSessionManager.getUserScreenName())
                cell.score.text = "1290"
            
        }

        cell.backgroundColor = UIColor.clear
        return cell
        
    }




}

extension ViewRankingViewController : UITableViewDelegate {
    
    
    
}
