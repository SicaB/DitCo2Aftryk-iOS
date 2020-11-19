//
//  SnapshotExtensions.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 12/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot {
    
    func decoded<Type: Decodable>() throws -> Type {
        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        let object = try JSONDecoder().decode(Type.self, from: jsonData)
        return object
    }
}

extension QuerySnapshot {
    func decoded<Type: Decodable>() throws -> [Type] {
        let objects: [Type] = try documents.map({ try $0.decoded() })
        return objects
    }
}
