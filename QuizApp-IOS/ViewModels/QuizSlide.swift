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
        QuizSlide(imageName: "java", title: "Java"),
        QuizSlide(imageName: "ios", title: "iOS"),
        QuizSlide(imageName: "android", title: "Android")
    ]
}
