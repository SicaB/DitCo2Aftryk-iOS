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
       
        
        setWeeklyDaysToChart()
        
        
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
                    self.setWeeklyDaysToChart()
                    self.viewDidAppear(true)

                }
                else  {
                    // you got an error
                }
            })
            
              self.dbFirestoreService.getDateInDatabase(completion: { date in
                if let dateInDatabase = date {
                    let today = self.getDate()
                    let weekday = self.getTodaysWeekDay()
                    if dateInDatabase != today {
                        let dailyCountToSave = DailyCo2Count(count: self.counter, date: dateInDatabase, weekday: weekday)
                        self.dbFirestoreService.saveDailyCo2Count(data: dailyCountToSave)
                        self.dbFirestoreService.deleteAccumulatedCount()
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
    
    func getCountsBasedOnWeekdays(){
        //dbFirestoreService.someDict.filter
    }
    
    func setWeeklyDaysToChart(){
        
        var dict: [String: Double] = [:]
        self.dbFirestoreService.getWeek(completion: { dictOfWeekdaysAndCounts in
             dict = dictOfWeekdaysAndCounts

            var yValues: [ChartDataEntry] = [
                ChartDataEntry(x: 0.0, y: 0.0),
                ChartDataEntry(x: 1.0, y: 0.0),
                ChartDataEntry(x: 2.0, y: 0.0),
                ChartDataEntry(x: 3.0, y: 0.0),
                ChartDataEntry(x: 4.0, y: 0.0),
                ChartDataEntry(x: 5.0, y: 0.0),
                ChartDataEntry(x: 6.0, y: 0.0)
            ]
    
            for (key, value) in dict {
                switch key {
                case "Monday":
                    yValues[0] = ChartDataEntry(x: 0.0, y: value)
                case "Tuesday":
                    yValues[1] = ChartDataEntry(x: 1.0, y: value)
                case "Wednesday":
                    yValues[2] = ChartDataEntry(x: 2.0, y: value)
                case "Thursday":
                    yValues[3] = ChartDataEntry(x: 3.0, y: value)
                case "Friday":
                    yValues[4] = ChartDataEntry(x: 4.0, y: value)
                case "Saturday":
                    yValues[5] = ChartDataEntry(x: 5.0, y: value)
                case "Sunday":
                    yValues[6] = ChartDataEntry(x: 6.0, y: value)
                default:
                    break
                }
                
            }
            
            let today = self.getTodaysWeekDay()
            switch today {
            case "Monday":
                yValues[0] = ChartDataEntry(x: 0.0, y: Double(self.counter))
            case "Tuesday":
                yValues[1] = ChartDataEntry(x: 1.0, y: Double(self.counter))
            case "Wednesday":
                yValues[2] = ChartDataEntry(x: 2.0, y: Double(self.counter))
            case "Thursday":
                yValues[3] = ChartDataEntry(x: 3.0, y: Double(self.counter))
            case "Friday":
                yValues[4] = ChartDataEntry(x: 4.0, y: Double(self.counter))
            case "Saturday":
                yValues[5] = ChartDataEntry(x: 5.0, y: Double(self.counter))
            case "Sunday":
                yValues[6] = ChartDataEntry(x: 6.0, y: Double(self.counter))
            default:
                break
            }
            
            
            
            self.setChartData(yValues: yValues)
            print(dict.values)
            
      })
        
    }
    

    func setChartData(yValues: [ChartDataEntry]){
        let set1 = LineChartDataSet(entries: yValues, label: "")
        let data = LineChartData(dataSet: set1)
        set1.drawValuesEnabled = false
        set1.circleColors = [NSUIColor(cgColor: UIColor.white.cgColor)]
        set1.colors = [NSUIColor(cgColor: UIColor.init(named: "ColorIcon")!.cgColor)]
        set1.lineWidth = 4
        set1.circleRadius = 7
        set1.drawFilledEnabled = false
        set1.setDrawHighlightIndicators(false)
        set1.highlightEnabled = true
        set1.highlightColor = NSUIColor(cgColor: UIColor.init(named: "ColorIcon")!.cgColor)
        set1.mode = LineChartDataSet.Mode.horizontalBezier
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
    
    func getTodaysWeekDay() -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: Date())
           return weekDay
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
        
        let weekdays: [String] = ["Man.", "Tirs.", "Ons.", "Tors.", "Fre.", "Lør.", "Søn."]
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.top
        lineChartView.xAxis.labelCount = 5
        lineChartView.xAxis.labelTextColor = .white
        lineChartView.xAxis.drawGridLinesEnabled = true
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekdays)
       
     
        lineChartView.legend.enabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.setScaleEnabled(false)
        
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = true
        
        lineChartView.rightAxis.maxWidth = 46
        lineChartView.leftAxis.maxWidth = 46
        
        lineChartView.setExtraOffsets(left: 20, top: 10, right: 20, bottom: 10)
        
      //  setChartData()
    
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

