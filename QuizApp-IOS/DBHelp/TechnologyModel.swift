//
//  TechnologyModel.swift
//  QuizApp-IOS
//
//  Created by admin on 3/18/22.
//

import Foundation
enum TechnologyTitle:String, CaseIterable {
    case Java = "Java"
    case IOS = "IOS"
    case Android = "Android"
    
}
func initTechTable(){
    for i in TechnologyTitle.allCases{
        DBCRUD.initDBCRUD.createTechnology(r: i.rawValue)
    }
    
}

