//
//  Prayer.swift
//  Footprints
//
//  Created by Daniel Nam on 3/3/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import Foundation

struct Prayer {
    let prayerID: String
    let authorName: String
    let prayerRequest: String
    let date: Date
    let answered: Bool
    let footprints: Int
    
    init?(prayerID: String, dict: [String: Any]) {
        self.prayerID = prayerID
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard
        let authorName = dict["authorName"] as? String,
        let prayerRequest = dict["prayerRequest"] as? String,
        let dateString = dict["date"] as? String,
        let date = dateFormatter.date(from: dateString),
        let answered = dict["answered"] as? Bool,
        let footprints = dict["footprints"] as? Int
            else { return nil }
        
        self.authorName = authorName
        self.prayerRequest = prayerRequest
        self.date = date
        self.answered = answered
        self.footprints = footprints

    }
}
