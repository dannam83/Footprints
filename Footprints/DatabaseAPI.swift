//
//  DatabaseService.swift
//  Footprints
//
//  Created by Daniel Nam on 3/1/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DatabaseAPI {
    static let shared = DatabaseAPI()
    private init() {}
    
    let usersReference = Database.database().reference().child("users")
    
    let prayersReference = Database.database().reference().child("prayers")
    
    let intercessorsReference = Database.database().reference().child("shares")
}
