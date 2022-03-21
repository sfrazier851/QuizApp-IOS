//
//  QuizSlide.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/18/22.
//

import Foundation

struct QuizSlide {
    var imageName: String
    var title: String
    
    static let collection: [QuizSlide] = [
        QuizSlide(imageName: "java_2", title: "Java"),
        QuizSlide(imageName: "apple", title: "iOS"),
        QuizSlide(imageName: "android_2", title: "Android")
    ]
}
