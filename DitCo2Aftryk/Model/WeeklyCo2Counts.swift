//
//  WeeklyCo2Counts.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 29/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation

struct WeeklyCo2Counts: Decodable {
    var size: Double
//    var date: String
    var weekday: String
//    var created: Date
    
    init(size: Double, weekday: String) {
        self.size = size
 //       self.date = date
        self.weekday = weekday
  //      self.created = created
        
    }
}

