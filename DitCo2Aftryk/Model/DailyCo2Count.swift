//
//  DailyCo2Count.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 12/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation

struct DailyCo2Count: Decodable {
    var count: Float
    var date: String
    
    init(count: Float, date: String) {
        self.count = count
        self.date = date
        
    }
}
