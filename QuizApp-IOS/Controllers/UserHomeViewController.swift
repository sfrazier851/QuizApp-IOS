//
//  UserHomeViewController.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/17/22.
//

import UIKit
import UserNotifications

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedQuizPageControl: UIPageControl!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var takeQuizButton: UIButton!
    
    @IBOutlet var uhview: UIView!
    
    @IBOutlet weak var leaderBoardsButton: UIButton!
    
    @IBOutlet weak var upgradeAccountButton: UIButton!
    
    @IBOutlet weak var feedbackButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        //setupImageBackground()
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleHollowButton(takeQuizButton)
        Utilities.styleHollowButton(feedbackButton)
        
        // upgrade account button starts out as hidden
        Utilities.styleFilledButton(upgradeAccountButton)
        upgradeAccountButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        upgradeAccountButton.layer.borderWidth = 2
        upgradeAccountButton.layer.borderColor = K.Color.Blue.cgColor
        upgradeAccountButton.tintColor = .white
        upgradeAccountButton.isHidden = true
        
        Utilities.styleHollowButton(leaderBoardsButton)
        leaderBoardsButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        leaderBoardsButton.layer.borderWidth = 2
        leaderBoardsButton.layer.borderColor = K.Color.Blue.cgColor
        leaderBoardsButton.tintColor = .white
        let userSub = DBCRUD.initDBCRUD.getUserSubscription(id: (LoginPort.user?.ID)!)
        if userSub == 1 {
            leaderBoardsButton.isHidden = true
            upgradeAccountButton.isHidden = false
        } else {
            upgradeAccountButton.isHidden = true
          }
        
        
        welcomeUserLabel.text = "Welcome, \(String(describing: LoginPort.user!.UserName!))."
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 5 total new quizzes were created
        UIApplication.shared.applicationIconBadgeNumber = 5
        // more specific totals for each technology type
        K.latestNewQuizTypesAndCount["Java"]! += 2
        K.latestNewQuizTypesAndCount["iOS"]! += 2
        K.latestNewQuizTypesAndCount["Android"]! += 1
        
        
        var message = "\(UIApplication.shared.applicationIconBadgeNumber) new quiz(zes).\n"
        // add specific totals for new quizzes by technology type
        for key in K.latestNewQuizTypesAndCount.keys {
            if K.latestNewQuizTypesAndCount[key]! > 0 {
                message.append("\(K.latestNewQuizTypesAndCount[key]!) new \(key).\n")
            }
        }
        
        // notify user of new quizzes
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                // reset badge number to 0
                UIApplication.shared.applicationIconBadgeNumber = 0//
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        quizCollectionView.backgroundColor = .systemGroupedBackground
        quizCollectionView.collectionViewLayout = layout
        // snap each cell to fill view (no free scrolling)
        quizCollectionView.isPagingEnabled = true
        quizCollectionView.showsHorizontalScrollIndicator = false
        // rounded edges
        quizCollectionView.layer.cornerRadius = 25.0
        quizCollectionView.layer.masksToBounds = true
        quizCollectionView.backgroundColor = .clear
        
        showTitle(atIndex: 0)
    }
    
    private func setupPageControl() {
        selectedQuizPageControl.numberOfPages = QuizSlide.collection.count
        selectedQuizPageControl.backgroundColor = .clear
        selectedQuizPageControl.currentPageIndicatorTintColor = K.Color.Orange
        selectedQuizPageControl.pageIndicatorTintColor = K.Color.Blue
    }

    private func showTitle(atIndex index: Int) {
        let slide = QuizSlide.collection[index]
        quizTitleLabel.text = slide.title
    }
    
    private func setupImageBackground() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "mainBg.png")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
         }
    }
    
    @IBAction func takeQuiz(_ sender: UIButton) {
        
        //CHECK SUBSCRIPTION
        if DBCRUD.initDBCRUD.getNumberOfAttempts(id: (LoginPort.user?.ID!)!, date: Utilities.formatDate(date: Date())) >= 2 && K.user_subscription == 1 {
            
            let dialogMessage = UIAlertController(title: "Alert", message: "You already reached your daily maximum attempts. Upgrade to a paid subscription for unlimited attempts.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
               
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
            
        } else {
          
            if K.user_subscription == 1 {
                K.dailyAttempt += 1
            }
            
            switch quizTitleLabel.text?.lowercased() {
                
                case "java":
                    K.currentPage = "Java"
                    PresenterManager.shared.show(vc: .java)
                case "ios":
                    K.currentPage = "IOS"
                    PresenterManager.shared.show(vc: .ios)
                case "android":
                    K.currentPage = "Android"
                    PresenterManager.shared.show(vc: .android)
                default:
                    print("No Controllers!")
                
            }
        
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        LoginPort.initLogin.logout()
        PresenterManager.shared.show(vc: .login)
    }
    
    @IBAction func upgradeAccountButtonTapped(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Alert", message: "Redirecting to payment processor site... ...your subscription is now active.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // switch button visibility
            DispatchQueue.main.async {
                self.leaderBoardsButton.isHidden = false
                self.upgradeAccountButton.isHidden = true
            }
            // update subscription for user
            let u = LoginPort.user!
            //print(u.UserName, u.Email)// confirm user is populated
            // set subscription for user to paid
            u.Subscript = 0
            K.user_subscription = 0
            DBCRUD.initDBCRUD.updateUser(us: u)//currently getting error
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    @IBAction func showRankingsPage(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .rankingByTech)
        
    }
    
    @IBAction func showFeedback(_ sender: UIButton) {
        
        PresenterManager.shared.show(vc: .feedback)
        
    }
    
    
}

extension UserHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // set number of elements in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        QuizSlide.collection.count
    }
    
    // populate cells with QuizSlide data/images
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // prevents app crashing, worst case is it returns empy collection view cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.ReuseIdentifier.selectQuizCollectionViewCell, for: indexPath) as? SelectQuizCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.backgroundColor = indexPath.item % 2 == 0 ? .systemRed : .systemBlue
        
        
        let imageName = QuizSlide.collection[indexPath.item].imageName
        //print(imageName)
        let image = UIImage(named: imageName) ?? UIImage()
        cell.configure(image: image)
        
        //cell.layer.cornerRadius = 25.0
        //cell.contentView.layer.borderWidth = 8.0
        
        cell.contentView.layer.cornerRadius = 25.0
        //cell.contentView.layer.borderWidth = 8.0
        //cell.contentView.layer.borderColor = K.Color.Blue.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = K.Color.Orange.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10.0)
        cell.layer.shadowRadius = 6.0
        cell.layer.shadowOpacity = 0.15
        cell.layer.cornerRadius = 25.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
    // set cell size to fill collection view frame
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // no space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // update quiz title and page control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        showTitle(atIndex: index)
        selectedQuizPageControl.currentPage = index
    }
    
    
    
}
