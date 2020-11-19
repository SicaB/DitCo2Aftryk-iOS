//
//  ViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 15/09/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    private var dbFirestoreService = DBFirestoreService()
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var enterCo2Btn: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var co2Counter: UILabel!
    
    
    @IBAction func enterCo2(_ sender: Any) {
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        progressBar.lineWidth = 15
    
        progressBar.safePercent = 100
        
        //progressBar.setProgress(to: 1, withAnimation: true)
        
        // listen to database updates when count is changed
        db.collection("countCollection").document("dailyCount").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
            
            
              print("Current data: \(data)")
              self.dbFirestoreService.getDailyCo2Count(completion: { count in
                  if let oldCount = count {
                    self.co2Counter.text = String(oldCount)
                }
                else  {
                    // you got an error
                }
            })
            
            }
        
       
        

    }
    
    private func setup() {
        let topGradientColor = UIColor(named: "HighlightGreen")
             
        let bottomGradientColor = UIColor(named: "DarkGreen")

        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = enterCo2Btn.bounds

        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.locations = [0.0, 1.0]

        enterCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        
        enterCo2Btn.layer.cornerRadius = 6
        enterCo2Btn.layer.masksToBounds = true
        enterCo2Btn.layer.borderWidth = 1.0
        enterCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    
    }


}

