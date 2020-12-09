//
//  BusViewController.swift
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

class BusViewController: UIViewController {
    
    @IBOutlet weak var busSaveCo2Btn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    let parentVC = ParentInputViewController()
    let busInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "", input: 0)
    private var dailyCount = DailyCo2Count(count: 0, date: "", weekday: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
       
    }
    
    @IBAction func saveBusCo2(_ sender: Any) {
        let date = parentVC.getDateAsString()
        let weekday = parentVC.getTodaysWeekDay()
        if let inputValue = busInputTextField.text {
            if (inputValue == "," || inputValue.isEmpty) {
                // create the alert
                       let alert = UIAlertController(title: "Intet indtastet!", message: "Indtast hvor mange km du har kørt.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                return
                
            } else {
                let input = NumberFormatter().number(from: busInputTextField.text!)
                if let inputNumber = input {
                    let calculatedCo2 = Float(truncating: inputNumber) * 0.069
                    co2Input = Co2InputData(source: "Bus Transport", size: calculatedCo2, date: date, input: Float(truncating: inputNumber))
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
        if busInputTextField.text?.isEmpty == false {
            let input = NumberFormatter().number(from: busInputTextField.text!)
            if let number = input {
                let calculatedCo2 = Float(truncating: number) * 0.069
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
        
        gradientLayer.frame = busSaveCo2Btn.bounds
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]

        busSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        busSaveCo2Btn.layer.cornerRadius = 6
        busSaveCo2Btn.layer.masksToBounds = true
        busSaveCo2Btn.layer.borderWidth = 1.0
        busSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
       
        busInputTextField.label.text = "Indtast km"
        busInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Add material textfield to the ui
        parentVC.addTextField(textField: busInputTextField, view: self.view, height: 350)
        
        emittedCo2.label.text = "Udledt CO2"
        parentVC.addEmittedTextField(textField: emittedCo2, height: 200, view: self.view)

        //Stack View
        stackView.addArrangedSubview(busInputTextField)
        stackView.addArrangedSubview(emittedCo2)
        stackView.addArrangedSubview(busSaveCo2Btn)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
    }

}
