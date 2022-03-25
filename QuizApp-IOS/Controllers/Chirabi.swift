//
//  Chirabi.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import Foundation

enum Arts
{
    case Chaos, Celestial, Hyper, Elem, Weapon, Emotion, Ragnarok, Cataclysm, Aura, Force
}

class Chirabi
{
    let name: String
    let bio: String
    let Art: Arts
    
    init(Name: String, BIO: String, At: Arts)
    {
        name = Name
        bio = BIO
        Art = At
    }
    
}
