//
//  PrayersSnapshot.swift
//  Footprints
//
//  Created by Daniel Nam on 3/3/18.
//  Copyright © 2018 Daniel Nam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct PrayersSnapshot {
    
    let prayers: [Prayer]
    
    init?(with snapshot: DataSnapshot) {
        var prayers = [Prayer]()
        guard let snapDict = snapshot.value as? [String: [String: Any]] else { return nil }
        
        for snap in snapDict {
            guard let prayer = Prayer(prayerID: snap.key, dict: snap.value)
                else { continue }
            prayers.append(prayer)
        }

        self.prayers = prayers
    }
}
