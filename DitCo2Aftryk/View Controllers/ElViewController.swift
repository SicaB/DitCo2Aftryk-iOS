//
//  ElViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 21/10/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class ElViewController: UIViewController {
    
    @IBOutlet weak var elSaveCo2Btn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    let parentVC = ParentInputViewController()
    let elInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "")
    private var dailyCount = DailyCo2Count(count: 0, date: "", weekday: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func saveElCo2(_ sender: Any) {
        let date = parentVC.getDateAsString()
        let weekday = parentVC.getCorrectWeekDay()
        if let inputValue = elInputTextField.text {
            if (inputValue == "," || inputValue.isEmpty) {
                // create the alert
                       let alert = UIAlertController(title: "Intet indtastet!", message: "Indtast hvor mange kWh du har brugt.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                return
            } else {
                let input = NumberFormatter().number(from: elInputTextField.text!)
                if let inputNumber = input {
                    let calculatedCo2 = Float(truncating: inputNumber) * 0.244
                co2Input = Co2InputData(source: "el", size: calculatedCo2, date: date)
                dailyCount = DailyCo2Count(count: calculatedCo2, date: date, weekday: weekday)
                parentVC.saveInputData(input: co2Input)
                parentVC.saveDailyCount(count: dailyCount)
                
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
            
        } else {
            print("There is no data to save!")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if elInputTextField.text?.isEmpty == false {
            let input = NumberFormatter().number(from: elInputTextField.text!)
            if let number = input {
                let calculatedCo2 = Float(truncating: number) * 0.244
                emittedCo2.text = String(format: "%.2f", calculatedCo2)
            }
            
        } else {
            emittedCo2.text = nil
        }
    }
    
    private func setup() {
        
        let topGradientColor = UIColor(named: "HighlightGreen")
        let bottomGradientColor = UIColor(named: "DarkGreen")
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = elSaveCo2Btn.bounds
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]

        elSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        elSaveCo2Btn.layer.cornerRadius = 6
        elSaveCo2Btn.layer.masksToBounds = true
        elSaveCo2Btn.layer.borderWidth = 1.0
        elSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    
        elInputTextField.label.text = "Indtast kWh"
        elInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Add material textfield to the ui
        parentVC.addTextField(textField: elInputTextField, view: self.view, height: 350)
        
        emittedCo2.label.text = "Udledt CO2 i kg"
        parentVC.addEmittedTextField(textField: emittedCo2, height: 200, view: self.view)
        
        //Stack View
        stackView.addArrangedSubview(elInputTextField)
        stackView.addArrangedSubview(emittedCo2)
        stackView.addArrangedSubview(elSaveCo2Btn)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
    }


}
