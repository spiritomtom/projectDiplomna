//
//  dataBase.swift
//  project
//
//  Created by Petko Dapchev on 26.01.21.
//

import Foundation
import UIKit
import SQLite3

class dataBase: UIViewController{
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Locations.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
        print("Problem with database")
        return
    }
    let createTableQuery = "CREATE TABLE IF NOT EXISTS Locations(id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(50));"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("All good!")
    }
    
}
