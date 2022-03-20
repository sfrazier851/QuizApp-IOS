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
    
    static var collection: [QuizSlide] = []
    
    static func setSlides(quizzes: [Quiz]) {
        for quiz in quizzes {
            collection.append(QuizSlide(imageName: quiz.imageName, title: quiz.name))
        }
    }
    /*
    [
        QuizSlide(imageName: "imSlide1", title: "Java"),
        QuizSlide(imageName: "imSlide2", title: "iOS"),
        QuizSlide(imageName: "imSlide3", title: "Android")
    ]*/
}
