//
//  Users.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/28/22.
//

import Foundation

class User
{
    var Name: String
    
    var Android_Score: String
    var iOS_Score: String
    var Java_Score: String
    
    init(name: String, AScore: Int = 0, iScore: Int = 0, JScore: Int = 0)
    {
        Name = name;
        Android_Score = String(AScore);
        iOS_Score = String(iScore);
        Java_Score = String(JScore);
    }
}
