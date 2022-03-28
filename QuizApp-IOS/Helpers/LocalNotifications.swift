//
//  LocalNotification.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/27/22.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotifications: NSObject, UNUserNotificationCenterDelegate {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    // request user permission to show notifications
    func notificationRequest() {
        
        // initialize the dictionary ["Java":0, "iOS":0, "Android":0] in UserDefaults
        UserDefaults.standard.set(K.latestNewQuizTypesAndCount, forKey: K.UserDefaults.latestNewQuizAndTypesCount)
        print(UserDefaults.standard.object(forKey: K.UserDefaults.latestNewQuizAndTypesCount) as! [String:Int])
        // initialize app icon badge count in User Defaults
        UserDefaults.standard.set(UIApplication.shared.applicationIconBadgeNumber, forKey: K.UserDefaults.appIconBadgeCount)
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        userNotificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications.")
            }
        }
    }
    
    // send new quiz notification
    func sendNewQuizNotification() {
        
        // get user default values for app icon badge count
        let appIconBadgeCount = UserDefaults.standard.integer(forKey: K.UserDefaults.appIconBadgeCount)
        // get dictionary for ["Java":0,"iOS":0,"Android":0] from user defaults (values might not be 0)
        let latestNewQuizTypesAndCount = UserDefaults.standard.object(forKey: K.UserDefaults.latestNewQuizAndTypesCount) as! [String:Int]
        
        var message = ""
        
        for key in latestNewQuizTypesAndCount.keys {
            if latestNewQuizTypesAndCount[key]! > 0 {
                message.append("\(latestNewQuizTypesAndCount[key]!) new \(key) quiz(zes).\n")
            }
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(appIconBadgeCount) new quiz(zes) added!"
        notificationContent.body = message
        notificationContent.badge = NSNumber(value: appIconBadgeCount)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "newQuizNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
                return
            }
        }
    }
    
    // delegate function for when "didReceive response"
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // RESET values back to zero...
        // set user defaults app icon badge count to 0
        UserDefaults.standard.set(0, forKey: K.UserDefaults.appIconBadgeCount)
        // get dictionary for ["Java":0,"iOS":0,"Android":0] from user defaults (values might not be 0)
        var latestNewQuizTypesAndCount = UserDefaults.standard.object(forKey: K.UserDefaults.latestNewQuizAndTypesCount) as! [String:Int]
        // set app icon badge number to 0
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = UserDefaults.standard.integer(forKey: K.UserDefaults.appIconBadgeCount)
        }
        // reset new quiz counts by technology to 0
        for key in latestNewQuizTypesAndCount.keys {
            if latestNewQuizTypesAndCount[key]! > 0 {
                latestNewQuizTypesAndCount[key]! = 0
            }
        }
        UserDefaults.standard.set(latestNewQuizTypesAndCount, forKey: K.UserDefaults.latestNewQuizAndTypesCount)
        completionHandler()
    }

    // delegate function for when "willPresent notification"
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge])
    }
}
