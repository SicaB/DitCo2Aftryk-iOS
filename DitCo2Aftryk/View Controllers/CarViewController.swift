//
//  CarViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 20/10/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CarViewController: UIViewController {
    
    let parentVC = ParentInputViewController()
  
    @IBOutlet var carView: UIView!
 
    @IBOutlet weak var emittedCo2: UITextField!
    @IBOutlet weak var carSaveCo2Btn: UIButton!
    
    let gradientLayer = CAGradientLayer()
    let carInputTextField = MDCOutlinedTextField()
    let carBtn = MDCButton()
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "")
    private var dailyCount = DailyCo2Count(count: 0, date: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    
    
    }
    
    
    @IBAction func saveCarCo2(_ sender: Any) {
        
        let date = parentVC.getDate()
        if let inputValue = carInputTextField.text {
            let inputFloat = (inputValue as NSString).floatValue
            co2Input = Co2InputData(source: "car", size: inputFloat, date: date)
            dailyCount = DailyCo2Count(count: inputFloat, date: date)
            parentVC.saveInputData(input: co2Input)
            parentVC.saveDailyCount(count: dailyCount)
            
            self.navigationController!.popToRootViewController(animated: true)
        
        }
        
        
        print("There is no data to save!")
        
        
        
        
        
    }
    
    private func setup() {
        
        let topGradientColor = UIColor(named: "HighlightGreen")
             
        let bottomGradientColor = UIColor(named: "DarkGreen")

        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = carSaveCo2Btn.bounds

        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]

        //Vertical
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        //Horizontal
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.locations = [0.0, 1.0]

        carSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)

        
//        enterCo2.layer.cornerRadius = 4
//        enterCo2.layer.masksToBounds = true
//        enterCo2.layer.borderWidth = 1.0
//        enterCo2.layer.borderColor = UIColor.darkGray.cgColor
//        enterCo2.attributedPlaceholder = NSAttributedString(string: "Indtast antal km kørt", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
//        emittedCo2.layer.cornerRadius = 4
//        emittedCo2.layer.masksToBounds = true
//        emittedCo2.layer.borderWidth = 1.0
//        emittedCo2.layer.borderColor = UIColor.darkGray.cgColor
//        emittedCo2.attributedPlaceholder = NSAttributedString(string: "Udledt Co2 i kg", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        carSaveCo2Btn.layer.cornerRadius = 18
        carSaveCo2Btn.layer.masksToBounds = true
        carSaveCo2Btn.layer.borderWidth = 1.0
        carSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    

       
        carInputTextField.label.text = "Antal km"
        
        // Add material textfield to the ui
        ParentInputViewController().addTextField(textField: carInputTextField, view: self.view, hight: 350)

        
        
    }
    
}