//
//  co2InputData.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 09/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation

struct Co2InputData: Decodable {
    var id: String = UUID().uuidString
    var source: String
    var size: Float
    var date: String
    var input: Float
    
    init(source: String, size: Float, date: String, input: Float) {
        self.source = source
        self.size = size
        self.date = date
        self.input = input
        
    }
}
