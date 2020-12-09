//
//  inputListData.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 07/12/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation

struct InputListData: Decodable {
    var source: String
    var input: Float
    
    init(source: String, input: Float) {
        self.source = source
        self.input = input
       
        
    }
}
