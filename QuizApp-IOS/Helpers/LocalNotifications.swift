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
        
        var message = ""//"\(UIApplication.shared.applicationIconBadgeNumber) new quiz(zes) total.\n"
        // add specific totals for new quizzes by technology type
        for key in K.latestNewQuizTypesAndCount.keys {
            if K.latestNewQuizTypesAndCount[key]! > 0 {
                message.append("\(K.latestNewQuizTypesAndCount[key]!) new \(key) quiz(zes).\n")
            }
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(UIApplication.shared.applicationIconBadgeNumber) new quiz(zes) added!"
        notificationContent.body = message
        notificationContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber)
        
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
        // set app icon badge number to 0
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        // reset new quiz counts by technology to 0
        for key in K.latestNewQuizTypesAndCount.keys {
            if K.latestNewQuizTypesAndCount[key]! > 0 {
                K.latestNewQuizTypesAndCount[key]! = 0
            }
        }
        completionHandler()
    }

    // delegate function for when "willPresent notification"
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge])
    }
}
