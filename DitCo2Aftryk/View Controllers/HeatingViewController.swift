//
//  HeatingViewController.swift
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

class HeatingViewController: UIViewController {
    
    @IBOutlet weak var heatingSaveCo2Btn: UIButton!
    @IBOutlet weak var pickerViewTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!

    let parentVC = ParentInputViewController()
    let heatingInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
    
    var selectedHeatingType: String?
    let heatingType = ["Vælg type", "Fjernvarme", "Bygas", "Fjernkøling"]
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "")
    private var dailyCount = DailyCo2Count(count: 0, date: "", weekday: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createAndSetupPickerView()
        dismissAndClosePickerView()
    }
    
    @IBAction func saveHeatingCo2(_ sender: Any) {
        let date = parentVC.getDateAsString()
        let weekday = parentVC.getCorrectWeekDay()
        if let inputValue = heatingInputTextField.text {
            if (inputValue == "," || inputValue.isEmpty) {
            // create the alert
                   let alert = UIAlertController(title: "Intet indtastet!", message: "Indtast hvor mange kWh du har brugt.", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
            return
        } else {
                let input = NumberFormatter().number(from: heatingInputTextField.text!)
            if let inputNumber = input {
                let calculatedCo2 = Float(truncating: inputNumber) * self.co2BasedOnHeatingType()
                co2Input = Co2InputData(source: "heating", size: calculatedCo2, date: date)
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
        if heatingInputTextField.text?.isEmpty == false && co2BasedOnHeatingType() != 0.0 {
            let input = NumberFormatter().number(from: heatingInputTextField.text!)
            if let number = input {
                let calculatedCo2 = Float(truncating: number) * self.co2BasedOnHeatingType()
                emittedCo2.text = String(format: "%.2f", calculatedCo2)
            }
            
        } else {
            heatingInputTextField.text = nil
            emittedCo2.text = nil
        }
    }
    
    @objc func noHeatingTypeSelected(textField: UITextField) {
        if co2BasedOnHeatingType() == 0.0 {
            heatingInputTextField.text = nil
            emittedCo2.text = nil
            // create the alert
                   let alert = UIAlertController(title: "", message: "Vælg venligst varme type.", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        
        } else {
            pickerViewTextField.layer.borderColor = nil
        }
    }
    
    func co2BasedOnHeatingType() -> Float{
        var co2Number: Float?
        switch selectedHeatingType {
        case "vælg type":
            co2Number = 0.0
        case "Fjernvarme":
            co2Number = 0.080
        case "Bygas":
            co2Number = 0.142
        case "Fjernkøling":
            co2Number = 0.041
        default:
            co2Number = 0.0
            
        }
        return co2Number!
    }
    
    func createAndSetupPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.pickerViewTextField.inputView = pickerView
        pickerView.backgroundColor = UIColor(named: "BackgroundColorBtn")
        
    }
    
    
    func dismissAndClosePickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(self.dismissAction))
        toolbar.setItems([flexButton, button], animated: true)
        toolbar.isUserInteractionEnabled = true
        self.pickerViewTextField.inputAccessoryView = toolbar
        toolbar.barTintColor = UIColor(named: "BackgroundColorBtn")
    }
    
    @objc func dismissAction(){
        self.view.endEditing(true)
    }

    private func setup() {
        
        let topGradientColor = UIColor(named: "HighlightGreen")
        let bottomGradientColor = UIColor(named: "DarkGreen")
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = heatingSaveCo2Btn.bounds
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]

        heatingSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        heatingSaveCo2Btn.layer.cornerRadius = 6
        heatingSaveCo2Btn.layer.masksToBounds = true
        heatingSaveCo2Btn.layer.borderWidth = 1.0
        heatingSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
       
        heatingInputTextField.label.text = "Indtast kWh"
        heatingInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Add material textfield to the ui
        parentVC.addTextField(textField: heatingInputTextField, view: self.stackView, height: 350)
        
        emittedCo2.label.text = "Udledt CO2 i kg"
        parentVC.addEmittedTextField(textField: emittedCo2, height: 200, view: self.view)
        
        //Stack View
        stackView.addArrangedSubview(pickerViewTextField)
        stackView.addArrangedSubview(heatingInputTextField)
        stackView.addArrangedSubview(emittedCo2)
        stackView.addArrangedSubview(heatingSaveCo2Btn)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerViewTextField.layer.borderColor = UIColor(named: "ColorIcon")?.cgColor
        pickerViewTextField.layer.borderWidth = 1.0
        pickerViewTextField.layer.cornerRadius = 6
        pickerViewTextField.layer.masksToBounds = true
        
        heatingInputTextField.addTarget(self, action: #selector(noHeatingTypeSelected(textField:)), for: .touchDown)

    }

}

extension HeatingViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.heatingType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.heatingType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedHeatingType = self.heatingType[row]
        self.pickerViewTextField.text = self.selectedHeatingType
        heatingInputTextField.text = nil
        emittedCo2.text = nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: heatingType[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}
