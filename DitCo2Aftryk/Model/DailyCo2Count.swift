//
//  DailyCo2Count.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 12/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation
import Firebase

struct DailyCo2Count: Decodable {
    var count: Float
    var date: String
    var weekday: String
    
    init(count: Float, date: String, weekday: String) {
        self.count = count
        self.date = date
        self.weekday = weekday
        
    }
}
