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
    @IBOutlet weak var pickerViewTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
 //   let gradientLayer = CAGradientLayer()
    let parentVC = ParentInputViewController()
    let carInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()

    var selectedCarType: String?
    let carType = ["Vælg bil", "Lille bil", "Mellemstor bil", "Stor bil", "Diesel bil", "Hybrid bil", "El-bil"]

    private var co2Input = Co2InputData(source: "", size: 0, date: "")
    private var dailyCount = DailyCo2Count(count: 0, date: "", weekday: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createAndSetupPickerView()
        dismissAndClosePickerView()
        
    }
    
    @IBAction func saveCarCo2(_ sender: Any) {
        let date = parentVC.getDateAsString()
        let weekday = parentVC.getCorrectWeekDay()
        if let inputValue = carInputTextField.text {
            if (inputValue == "," || inputValue.isEmpty) {
                // create the alert
                       let alert = UIAlertController(title: "Intet indtastet!", message: "Indtast hvor mange km du har kørt.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                return
            } else {
                let input = NumberFormatter().number(from: carInputTextField.text!)
                if let inputNumber = input {
                    let calculatedCo2 = Float(truncating: inputNumber) * self.co2BasedOnCarType()
                    co2Input = Co2InputData(source: "car", size: calculatedCo2, date: date)
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
        if carInputTextField.text?.isEmpty == false && co2BasedOnCarType() != 0.0 {
            pickerViewTextField.layer.borderColor = nil
            let input = NumberFormatter().number(from: carInputTextField.text!)
            if let number = input {
                let calculatedCo2 = Float(truncating: number) * self.co2BasedOnCarType()
                emittedCo2.text = String(format: "%.2f", calculatedCo2)
            }
            
        } else {
            carInputTextField.text = nil
            emittedCo2.text = nil
        }
    }
    
    
    @objc func noCartypeSelected(textField: UITextField) {
        if co2BasedOnCarType() == 0.0 {
            carInputTextField.text = nil
            emittedCo2.text = nil
            // create the alert
                   let alert = UIAlertController(title: "", message: "Vælg venligst bil type.", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        
        } else {
            pickerViewTextField.layer.borderColor = nil
        }
    }
    
    func co2BasedOnCarType() -> Float{
        var co2Number: Float?
        switch selectedCarType {
        case "vælg bil":
            co2Number = 0.0
        case "Lille bil":
            co2Number = 0.11
        case "Mellemstor bil":
            co2Number = 0.133
        case "Stor bil":
            co2Number = 0.183
        case "Diesel bil":
            co2Number = 0.16
        case "Hybrid bil":
            co2Number = 0.084
        case "El-bil":
            co2Number = 0.043
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
    
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    
        carInputTextField.label.text = "Indtast km"
        carInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)

        // Add material textfield to the ui
        parentVC.addTextField(textField: carInputTextField, view: self.stackView, height: 350)

        emittedCo2.label.text = "Udledt CO2 i kg"
        parentVC.addEmittedTextField(textField: emittedCo2, height: 200, view: self.view)
        
        //Stack View
        stackView.addArrangedSubview(pickerViewTextField)
        stackView.addArrangedSubview(carInputTextField)
        stackView.addArrangedSubview(emittedCo2)
        stackView.addArrangedSubview(carSaveCo2Btn)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerViewTextField.layer.borderColor = UIColor(named: "ColorIcon")?.cgColor
        pickerViewTextField.layer.borderWidth = 1.0
        pickerViewTextField.layer.cornerRadius = 6
        pickerViewTextField.layer.masksToBounds = true
        
        carInputTextField.addTarget(self, action: #selector(noCartypeSelected(textField:)), for: .touchDown)
            
        }
    
    }

extension CarViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.carType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.carType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCarType = self.carType[row]
        self.pickerViewTextField.text = self.selectedCarType
        carInputTextField.text = nil
        emittedCo2.text = nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: carType[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}








