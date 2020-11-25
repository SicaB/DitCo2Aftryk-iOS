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
  
    @IBOutlet var carView: UIView!
 
    @IBOutlet weak var carSaveCo2Btn: UIButton!
    
 //   let gradientLayer = CAGradientLayer()
    let parentVC = ParentInputViewController()
    let carInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if carInputTextField.text?.isEmpty == false {
            let input = Float(carInputTextField.text!)!
            let calculatedCo2 = input * 20
            emittedCo2.text = String(calculatedCo2)
        } else {
            emittedCo2.text = nil
        }
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
        
        carSaveCo2Btn.layer.cornerRadius = 6
        carSaveCo2Btn.layer.masksToBounds = true
        carSaveCo2Btn.layer.borderWidth = 1.0
        carSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    
        //
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    

       
        carInputTextField.label.text = "Indtast km"
        carInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Add material textfield to the ui
        parentVC.addTextField(textField: carInputTextField, view: self.view, hight: 350)
        
        emittedCo2.label.text = "Udledt CO2"
        
        parentVC.addEmittedTextField(textField: emittedCo2, view: self.view, hight: 200)

    }
    
}
