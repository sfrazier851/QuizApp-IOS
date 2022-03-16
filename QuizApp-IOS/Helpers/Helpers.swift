//
//  Helpers.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import Foundation

func delay(durationInSeconds seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
