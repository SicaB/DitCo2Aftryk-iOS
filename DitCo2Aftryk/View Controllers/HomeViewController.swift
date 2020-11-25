//
//  ViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 15/09/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit
import Firebase
import MBCircularProgressBar
import Charts
import TinyConstraints


class HomeViewController: UIViewController, ChartViewDelegate {
    
    private var dbFirestoreService = DBFirestoreService()
    let db = Firestore.firestore()
    var counter: Float = 0.0
    let deviceType = UIDevice().type
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor.black
        return chartView
    }()
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var enterCo2Btn: UIButton!
    @IBOutlet weak var homeScreenChartView: UIView!
    
    @IBAction func enterCo2(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // listen to database updates when count is changed
        db.collection("todaysCountAccumulated").document("todaysCount").addSnapshotListener { documentSnapshot, error in
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
                  if let dailyCount = count {
//                    self.co2Counter.text = String(oldCount)
                    self.counter = dailyCount
                    self.viewDidAppear(true)

                }
                else  {
                    // you got an error
                }
            })
            
              self.dbFirestoreService.getDateInDatabase(completion: { date in
                if let dateInDatabase = date {
                    let today = self.getDate()
                    if dateInDatabase != today {
                        let dailyCountToSave = DailyCo2Count(count: self.counter, date: dateInDatabase)
                        self.dbFirestoreService.saveDailyCo2Count(data: dailyCountToSave)
                        self.dbFirestoreService.deleteDailyCount()
                        self.dbFirestoreService.deleteAllInputs()
                        self.counter = 0.0
                        self.progressBar.value = 0
                    }
                }
                else {
                    
                }
            })
            
            }
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 5.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 2.0),
        ChartDataEntry(x: 4.0, y: 9.0),
        ChartDataEntry(x: 5.0, y: 10.0),
        ChartDataEntry(x: 6.0, y: 8.0)
    ]
    
    func setChartData(){
        let set1 = LineChartDataSet(entries: yValues, label: "something")
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       print(entry)
    }
    
    func progressBarSetup() {
        self.progressBar.value = CGFloat(self.counter)
        
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    private func setupUI() {
        
        // set progressbar value to 0 on first load
        self.progressBar.value = 0
        
        print("Running on: \(UIDevice().type)")
        
        let topGradientColor = UIColor(named: "HighlightGreen")
        let bottomGradientColor = UIColor(named: "DarkGreen")
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = enterCo2Btn.bounds

        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.locations = [0.0, 0.9]

        // Setup button
        enterCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        enterCo2Btn.layer.cornerRadius = 6
        enterCo2Btn.layer.masksToBounds = true
        enterCo2Btn.layer.borderWidth = 1.0
        enterCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
        
        // Setup chartView
        homeScreenChartView.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: homeScreenChartView)
        lineChartView.height(to: homeScreenChartView)
        
        setChartData()
    
    }
    
    private func device() {
        switch deviceType {
        case .iPhone5:
            progressBar.textOffset = CGPoint(x: 0, y: -170)
        case .iPhone5S:
            progressBar.textOffset = CGPoint(x: 0, y: -170)
        case .iPhone6:
            progressBar.textOffset = CGPoint(x: 0, y: -180)
        case .iPhone6Plus:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhone6S:
            progressBar.textOffset = CGPoint(x: 0, y: -180)
        case .iPhone6SPlus:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhone7:
            progressBar.textOffset = CGPoint(x: 0, y: -180)
        case .iPhone7Plus:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhone8:
            progressBar.textOffset = CGPoint(x: 0, y: -180)
        case .iPhone8Plus:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhoneX:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhoneXS:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhoneXSMax:
            progressBar.textOffset = CGPoint(x: 0, y: -230)
        case .iPhone11:
            progressBar.textOffset = CGPoint(x: 0, y: -220)
        case .iPhone11Pro:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhone11ProMax:
            progressBar.textOffset = CGPoint(x: 0, y: -230)
        case .iPhone12:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -210)
        case .iPhone12Mini:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        case .iPhone12Pro:
            // do tabbar
            progressBar.textOffset = CGPoint(x: 0, y: -210)
        case .unrecognized:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        default:
            progressBar.textOffset = CGPoint(x: 0, y: -200)
        }
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0) {
            self.progressBar.value = CGFloat(self.counter)
            self.device()
            
        }
    }


}

