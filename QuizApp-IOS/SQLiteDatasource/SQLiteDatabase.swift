//
//  SQLiteCDatabase.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/20/22.
//

import Foundation
import SQLite3

class SQLiteDatabase {
    private static let sharedInstance = SQLiteDatabase()
    private var database: OpaquePointer?
    
    static func getDatabase() -> OpaquePointer? {
        return sharedInstance.database
    }
    
    private init() {
        // Create a connection to the database
        do {
            // Get full path
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // Append sqlite db file name and extension to full path
            let fileUrl = documentDirectory.appendingPathComponent(K.SQLiteDatabase.dbFileName).appendingPathExtension(K.SQLiteDatabase.dbFileExtension)
            
            // Connect to db or create if doesn't exist
            if sqlite3_open(fileUrl.path, &database) != SQLITE_OK {
                print("error opening database")
            }
            print(fileUrl.path)
        } catch {
            print("Error connecting to the database: \(error)")
        }
    }
    
    
    private static func createTable(createTableScript: String) {
        if let db = SQLiteDatabase.sharedInstance.database {
            do {
                if sqlite3_exec(db, createTableScript, nil, nil, nil) != SQLITE_OK {
                    let error = String(cString: sqlite3_errmsg(db)!)
                    print("error creating table: \(error)")
                }
            }
        }
    }
    
    
    static func createTables() {
        let scripts = [ SQLiteTables.userTableScripts.joined(),
                        SQLiteTables.quizTableScripts.joined(),
                        SQLiteTables.questionAnswerTableScripts.joined(),
                        SQLiteTables.quizAttemptTableScripts.joined() ]
        
        for script in scripts {
            createTable(createTableScript: script)
        }
    }
    
}
