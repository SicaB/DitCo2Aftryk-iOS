//
//  DBFirestoreService.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 09/11/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class DBFirestoreService {
    
    let db = Firestore.firestore()
    var oldCount = DailyCo2Count(count: 0.0, date: "")
    
    
    func saveCo2(input: Co2InputData) {
        
        db.collection("inputData").document().setData([
            "id": input.id,
            "source": input.source,
            "size": input.size,
            "date": input.date
        ], merge: true) {
            err in
            if let err = err {
                print("Error writing to document: \(err)")
            } else {
                print("Co2 input succesfully written")
            }
        }
        
    }
    
//    func readArray(completion: @escaping (Float?, Error?) -> Void){
//
//        self.db.collection("countCollection").getDocuments { (snapshot, err) in
//           if let err = err {
//               print("Error getting documents: \(err)")
//                completion(nil, err)
//
//           } else {
//            guard snapshot != nil else {
//                return
//            }
//               for document in snapshot!.documents {
//                _ = document.data()
//                let count = document.get("count") as? Float
//                self.oldCount.count = count!
//                completion(self.oldCount.count, nil)
//                  print(count!)
//               }
//           }
//       }
//    }
    
    func getDailyCo2Count(completion: @escaping (Float?) -> Void) {
            let co2Count = db.collection("countCollection")
            var count: Float? = 0
            co2Count.getDocuments { (snapshot, _) in
            let documents = snapshot!.documents
            try! documents.forEach{ document in
                let dailyCount: DailyCo2Count = try document.decoded()
                count = dailyCount.count
                completion(count)
                print(count!)

            }
//            let dailyCount: [DailyCo2Count] = try! snapshot!.decoded()
//
//           // use this to print out all data in an array on seperate lines
//            dailyCount.forEach({ print($0)})
//                print(dailyCount[0])
        }
    }
    
    
    func updateDailyCo2Count(newCount: DailyCo2Count) {
        let docRef = db.collection("countCollection").document("dailyCount")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                self.getDailyCo2Count(completion: { count in
                    if let oldCount = count {
                        // use
                        self.oldCount.count = oldCount
                        docRef.setData([
                            "count": newCount.count + self.oldCount.count,
                            "date": newCount.date
                         ], merge: true)
                        print("Todays count value has been updated!")
                    }
                    else  {
                        // you got an error
                    }
                })
              }
            else {
                print("Document does not exist")
                docRef.setData([
                    "count": newCount.count,
                    "date": newCount.date
                ]) {
                    (error: Error?) in
                    if let error = error {
                        print("\(error.localizedDescription)")
                    } else {
                        print("Document was created")
                    }
                }
              }
        }
    }

    
    func deleteCo2(data: Co2InputData) {
        
    }
    
 }


