//
//  Helpers.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import Foundation

// general purpose "thread.sleep" then run completion function
func delay(durationInSeconds seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
