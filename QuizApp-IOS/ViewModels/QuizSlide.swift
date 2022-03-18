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
        QuizSlide(imageName: "imSlide1", title: "Java"),
        QuizSlide(imageName: "imSlide2", title: "iOS"),
        QuizSlide(imageName: "imSlide3", title: "Android")
    ]
}
