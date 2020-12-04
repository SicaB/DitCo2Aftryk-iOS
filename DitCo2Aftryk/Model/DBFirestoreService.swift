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
    var oldCount = DailyCo2Count(count: 0.0, date: "", weekday: "")
    
    
    func saveCo2(input: Co2InputData) {
        
        db.collection("inputData").document().setData([
            "id": input.id,
            "source": input.source,
            "size": input.size,
            "date": input.date,
            "created": Firebase.Timestamp.init(date: Date())
        ], merge: true) {
            err in
            if let err = err {
                print("Error writing to inputData document: \(err)")
            } else {
                print("Co2 input succesfully written")
            }
        }
        
    }
    
    func getDailyCo2Count(completion: @escaping (Float?) -> Void) {
            let collectionRef = db.collection("todaysCountAccumulated")
            var count: Float? = 0
            collectionRef.getDocuments { (snapshot, _) in
            let documents = snapshot!.documents
            try! documents.forEach{ document in
        
                let dailyCount: DailyCo2Count = try document.decoded()
                count = dailyCount.count
                completion(count)
                
                

            }
//            let dailyCount: [DailyCo2Count] = try! snapshot!.decoded()
//
//           // use this to print out all data in an array on seperate lines
//            dailyCount.forEach({ print($0)})
//                print(dailyCount[0])
        }
    }
    
    func getCo2Counts() {
            let collectionRef = db.collection("dailyCounts")
            collectionRef.getDocuments { (snapshot, _) in
//            let documents = snapshot!.documents
//            try! documents.forEach{ document in

                let counts: [WeeklyCo2Counts] = try! snapshot!.decoded()
                counts.forEach({ print($0)})

            }

        }
    
//    func getTodaysInput(){
//        let collectionRef = db.collection("dailyCounts")
//        collectionRef.getDocuments { (snapshot, _) in
////            let documents = snapshot!.documents
////            try! documents.forEach{ document in
//
//            let counts: [Co2InputData] = try! snapshot!.decoded()
//            counts.forEach({ print($0)})
//
//        }
//    }

    
    
    
    func getWeek(completion: @escaping ([String: Double]) -> Void){
        let collectionRef = db.collection("dailyCounts").order(by: "created", descending: true).limit(to: 6)
        
        var dictOfWeekdaysAndCounts = [String: Double]()
        var arrayOfWeekdays: [String] = []
        var arrayOfCounts: [Double] = []
           
        collectionRef.getDocuments  { (snapshot, err) in

                if let err = err {
                    print("error getting document monday: \(err)")
                    
                } else {
                    guard let snap = snapshot else { return }
                    for document in snap.documents {
                        
                        let data = document.data()
                        let weekday = data["weekday"] as? String ?? ""
                        let size = data["size"] as? Double ?? 0.0
                        
                        let newWeek = WeeklyCo2Counts(size: size, weekday: weekday)
                        
                        arrayOfCounts.append(newWeek.size)
                        arrayOfWeekdays.append(newWeek.weekday)
                        dictOfWeekdaysAndCounts = Dictionary(uniqueKeysWithValues: zip(arrayOfWeekdays, arrayOfCounts))
    
                        }
                    
                    completion(dictOfWeekdaysAndCounts)
                    
                    }
                    
                }
        }
    
    func getDateInDatabase(completion: @escaping (String?) -> Void) {
        let collectionRef = db.collection("todaysCountAccumulated")
        var dateInDatabase: String? = ""
        collectionRef.getDocuments{ (snapshot, _) in
            let documents = snapshot!.documents
            try! documents.forEach{ document in
                let date: DailyCo2Count = try document.decoded()
                dateInDatabase = date.date
                completion(dateInDatabase)
                
            }
            
        }
    }
    
    
    func updateDailyCo2Count(newCount: DailyCo2Count) {
        let docRef = db.collection("todaysCountAccumulated").document("todaysCount")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                self.getDailyCo2Count(completion: { count in
                    if let oldCount = count {
                        // use
                        self.oldCount.count = oldCount
                        docRef.setData([
                            "count": newCount.count + self.oldCount.count,
                            "date": newCount.date,
                            "weekday": newCount.weekday
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
                    "date": newCount.date,
                    "weekday": newCount.weekday
                ]) {
                    (error: Error?) in
                    if let error = error {
                        print("\(error.localizedDescription)")
                    } else {
                        print("TodaysCountAccumulated document was created")
                    }
                }
              }
        }
    }
    
    // function to save the accumulated daily count in a new collection
    func saveDailyCo2Count(data: DailyCo2Count) {
        db.collection("dailyCounts").document().setData([
            "size": data.count,
            "date": data.date,
            "weekday": data.weekday,
            "created": Firebase.Timestamp.init(date: Date())
        ], merge: true) {
            err in
            if let err = err {
                print("Error writing to dailyCounts document: \(err)")
            } else {
                print("Daily Co2 succesfully written")
            }
        }
    }
    
    func deleteLastInput(){
        let collectionRef = db.collection("inputData").order(by: "")
    }

    
    func deleteAccumulatedCount() {
        db.collection("todaysCountAccumulated").document("todaysCount").delete() { err in
            if let err = err {
                print("Error removing TodaysCount document: \(err)")
            } else {
                print("TodaysCount document successfully removed!")
            }
        }
    }
    
    func deleteAllInputs() {
        db.collection("inputData").getDocuments { (snapshot, err) in

                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in snapshot!.documents {

                         document.reference.delete()

                         }
                     }}
        
    }
    
 }


