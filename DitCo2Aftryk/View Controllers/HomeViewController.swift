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
    var dataSets = [LineChartDataSet]()
    var yValues: [ChartDataEntry] = [
             ChartDataEntry(x: 0.0, y: 0.0),
             ChartDataEntry(x: 1.0, y: 0.0),
             ChartDataEntry(x: 2.0, y: 0.0),
             ChartDataEntry(x: 3.0, y: 0.0),
             ChartDataEntry(x: 4.0, y: 0.0),
             ChartDataEntry(x: 5.0, y: 0.0),
             ChartDataEntry(x: 6.0, y: 0.0)
         ]
    var yValueHighlight = [ChartDataEntry]()
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
    
    @IBAction func didTabQuestionMark(){
        // create the alert
               let alert = UIAlertController(title: "Denne CO2-beregner hjælper dig med at holde styr på din CO2-udledning.", message: "Øverst ser du, hvor meget CO2 du har udledt på pågældende dag. Cirklen viser din daglige CO2-udledning. Når cirklen er fyldt, har du nået den gennemsnitlige CO2-udledning, som en dansker udleder om dagen, hvilket svarer til ca. 46 kg. Nederst kan du følge med i din udledning på ugentlig basis. God fornøjelse!", preferredStyle: UIAlertController.Style.alert)

               // add an action (button)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

               // show the alert
               self.present(alert, animated: true, completion: nil)
        return
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
                self.counter = 0
                self.setWeeklyDaysToChart()
                self.deleteSelectedChartValue()
                self.progressBar.value = 0
                self.navigationItem.title = "I dag"
                print("Document data was empty.")
                return
              }
            
            self.lineChartView.data?.notifyDataChanged()
            self.lineChartView.notifyDataSetChanged()
            self.navigationItem.title = "I dag"
              print("Current data: \(data)")
            
              self.dbFirestoreService.getDailyCo2Count(completion: { count in
                  if let dailyCount = count {
//                    self.co2Counter.text = String(oldCount)
                    self.counter = dailyCount
                    if self.counter >= 46 {
                        self.progressBar.progressColor = .systemRed
                        self.progressBar.progressStrokeColor = .systemRed
                    } else if self.counter < 46 {
                        self.progressBar.progressColor = UIColor(named: "ColorIcon")
                        self.progressBar.progressStrokeColor = UIColor(named: "ColorIcon")
                    }
                    
                    self.deleteSelectedChartValue()
                    self.setWeeklyDaysToChart()
                    self.viewDidAppear(true)

                }
                else  {
                   
                    print("Error")
                }
            })
            
              self.dbFirestoreService.getDateInDatabase(completion: { date in
                if let dateInDatabase = date {
                    let today = self.getDate()
                    let weekday = self.getYesterdaysWeekDay()
                    if dateInDatabase != today {
                        let dailyCountToSave = DailyCo2Count(count: self.counter, date: dateInDatabase, weekday: weekday)
                        self.dbFirestoreService.saveDailyCo2Count(data: dailyCountToSave)
                        self.dbFirestoreService.deleteAccumulatedCount()
                        self.dbFirestoreService.deleteAllInputs()
                        self.counter = 0.0
                        self.progressBar.value = 0
                        if self.yValueHighlight.count == 1 {
                            self.yValueHighlight.removeAll()
                        }
                      
                    
                    }
                }
                else {
                    
                }
            })
            
            }
    }
    
//    func getCountsBasedOnWeekdays(){
//        //dbFirestoreService.someDict.filter
//    }
    
    func setWeeklyDaysToChart(){
        
        var dict: [String: Double] = [:]
        self.dbFirestoreService.getWeek(completion: { dictOfWeekdaysAndCounts in
             dict = dictOfWeekdaysAndCounts
            
            
            for (key, value) in dict {
                switch key {
                case "Monday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[0] = ChartDataEntry(x: 0.0, y: value)
                    } else {
                        self.yValues[0] = ChartDataEntry(x: 0.0, y: 46)
                    }
                case "Tuesday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[1] = ChartDataEntry(x: 1.0, y: value)
                    } else {
                        self.yValues[1] = ChartDataEntry(x: 1.0, y: 46)
                    }
                case "Wednesday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[2] = ChartDataEntry(x: 2.0, y: value)
                    } else {
                        self.yValues[2] = ChartDataEntry(x: 2.0, y: 46)
                    }
                case "Thursday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[3] = ChartDataEntry(x: 3.0, y: value)
                    } else {
                        self.yValues[3] = ChartDataEntry(x: 3.0, y: 46)
                    }
                case "Friday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[4] = ChartDataEntry(x: 4.0, y: value)
                    } else {
                        self.yValues[4] = ChartDataEntry(x: 4.0, y: 46)
                    }
                case "Saturday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[5] = ChartDataEntry(x: 5.0, y: value)
                    } else {
                        self.yValues[5] = ChartDataEntry(x: 5.0, y: 46)
                    }
                case "Sunday":
                    let number = value as Double
                    if number <= 46 {
                        self.yValues[6] = ChartDataEntry(x: 6.0, y: value)
                    } else {
                        self.yValues[6] = ChartDataEntry(x: 6.0, y: 46)
                    }
                default:
                    break
                }
                
            }
            
            
            let today = self.getTodaysWeekDay()
            switch today {
            case "Monday":
                if self.counter <= 46 {
                    self.yValues[0] = ChartDataEntry(x: 0.0, y: Double(self.counter))
                } else {
                    self.yValues[0] = ChartDataEntry(x: 0.0, y: 46)
                }
            case "Tuesday":
                if self.counter <= 46 {
                    self.yValues[1] = ChartDataEntry(x: 1.0, y: Double(self.counter))
                } else {
                    self.yValues[1] = ChartDataEntry(x: 1.0, y: 46)
                }
            case "Wednesday":
                if self.counter <= 46 {
                    self.yValues[2] = ChartDataEntry(x: 2.0, y: Double(self.counter))
                } else {
                    self.yValues[2] = ChartDataEntry(x: 2.0, y: 46)
                }
            case "Thursday":
                if self.counter <= 46 {
                    self.yValues[3] = ChartDataEntry(x: 3.0, y: Double(self.counter))
                } else {
                    self.yValues[3] = ChartDataEntry(x: 3.0, y: 46)
                }
            case "Friday":
                if self.counter <= 46 {
                    self.yValues[4] = ChartDataEntry(x: 4.0, y: Double(self.counter))
                } else {
                    self.yValues[4] = ChartDataEntry(x: 4.0, y: 46)
                }
            case "Saturday":
                if self.counter <= 46 {
                    self.yValues[5] = ChartDataEntry(x: 5.0, y: Double(self.counter))
                } else{
                    self.yValues[5] = ChartDataEntry(x: 5.0, y: 46)
                }
            case "Sunday":
                if self.counter <= 46 {
                    self.yValues[6] = ChartDataEntry(x: 6.0, y: Double(self.counter))
                } else {
                    self.yValues[6] = ChartDataEntry(x: 6.0, y: 46)
                }
            default:
                break
            }
            
            
            self.setChartData(yValues: self.yValues)
            //print("dict values: \(dict.values)")
            
            
      })
        
    }
    
    func deleteSelectedChartValue(){
        self.yValueHighlight.removeAll()
        let set2 = LineChartDataSet(entries: self.yValueHighlight, label: "DataSet 2")
      
        if self.dataSets.count < 2 {
            self.dataSets.append(set2)
        } else {
            self.dataSets[1] = set2
        }
        
        let chartData = LineChartData(dataSets: self.dataSets)
        self.lineChartView.data = chartData
    }
    
    func setChartData2(yValuesHighligt: [ChartDataEntry]) {
        let set2 = LineChartDataSet(entries: self.yValueHighlight, label: "DataSet 2")
        set2.circleColors = [NSUIColor(cgColor: UIColor.white.cgColor)]
        set2.drawCircleHoleEnabled = true
        set2.circleRadius = 12
        set2.circleHoleRadius = 6
        set2.valueColors = [NSUIColor(cgColor: UIColor.white.cgColor)]
        set2.valueFont = UIFont(name: "Verdana", size: 10.0)!
        set2.setDrawHighlightIndicators(false)
        set2.circleHoleColor = NSUIColor(cgColor: UIColor.init(named: "DarkGreen")!.cgColor)
        
      
        if self.dataSets.count < 2 {
            self.dataSets.append(set2)
        } else {
            self.dataSets[1] = set2
        }
        
        let data = LineChartData(dataSets: self.dataSets)
        lineChartView.data = data
    }
    

    func setChartData(yValues: [ChartDataEntry]){
        let set1 = LineChartDataSet(entries: yValues, label: "DataSet 1")
        set1.drawValuesEnabled = false
        set1.valueColors = [NSUIColor(cgColor: UIColor.white.cgColor)]
        set1.circleColors = [NSUIColor(cgColor: UIColor.white.cgColor)]
        set1.colors = [NSUIColor(cgColor: UIColor.init(named: "ColorIcon")!.cgColor)]
        set1.lineWidth = 4
        set1.circleRadius = 7
        set1.drawFilledEnabled = false
        set1.setDrawHighlightIndicators(false)
        set1.highlightEnabled = true
        set1.highlightColor = NSUIColor(cgColor: UIColor.init(named: "ColorIcon")!.cgColor)
        set1.mode = LineChartDataSet.Mode.horizontalBezier
        
        if self.dataSets.count < 1 {
            self.dataSets.append(set1)
        } else {
            self.dataSets[0] = set1
        }
       
        
        //let data = LineChartData(dataSet: set1)
        let data = LineChartData(dataSets: self.dataSets)
        lineChartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        //print(self.yValues.firstIndex(of: entry)!)
        
        
        self.yValueHighlight.removeAll()
        lineChartView.notifyDataSetChanged()
        lineChartView.data?.notifyDataChanged()
        let indexOfEntry = self.yValues.firstIndex(of: entry)!
        
            //let today = self.getTodaysWeekDay()
        
        
        switch indexOfEntry {
        
        case 0:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Mandag"
            self.progressBar.value = CGFloat(self.yValues[0].y)
            
        case 1:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Tirsdag"
            self.progressBar.value = CGFloat(self.yValues[1].y)
           
        case 2:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Onsdag"
            self.progressBar.value = CGFloat(self.yValues[2].y)
            
        case 3:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Torsdag"
            self.progressBar.value = CGFloat(self.yValues[3].y)
            
        case 4:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Fredag"
            self.progressBar.value = CGFloat(self.yValues[4].y)
            
        case 5:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Lørdag"
            self.progressBar.value = CGFloat(self.yValues[5].y)
            
        case 6:
            self.yValueHighlight.append(entry)
            self.navigationItem.title = "Søndag"
            self.progressBar.value = CGFloat(self.yValues[6].y)
            
    
        default:
            break
        }
        
        setChartData2(yValuesHighligt: self.yValueHighlight)
       

    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        yValueHighlight.removeAll()
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
    
    
    func getYesterdaysWeekDay() -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let weekDay = dateFormatter.string(from: yesterday!)
        return weekDay
            
     }
    
 
    private func setupUI() {
        
        // set progressbar value to 0 on first load
        self.progressBar.value = 0.0
        
        
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
        lineChartView.delegate = self
        self.setWeeklyDaysToChart()
        
    
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
            self.progressBar?.value = CGFloat(self.counter)
            self.device()
            
        }
    }
    

}


