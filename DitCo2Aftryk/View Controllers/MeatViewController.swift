//
//  MeatViewController.swift
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

class MeatViewController: UIViewController {
    
    @IBOutlet weak var meatSaveCo2Btn: UIButton!
    @IBOutlet weak var meatContainerView: UIView!
    @IBOutlet weak var pickerViewTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    let parentVC = ParentInputViewController()
    let meatInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
    
    var selectedMeatType: String?
    let meatType = ["Vælg kød", "Okse", "Svin", "Kylling", "Lam"]
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "", input: 0)
    private var dailyCount = DailyCo2Count(count: 0, date: "", weekday: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createAndSetupPickerView()
        dismissAndClosePickerView()
        
    }
    
    @IBAction func saveMeatCo2(_ sender: Any) {
        let date = parentVC.getDateAsString()
        let weekday = parentVC.getTodaysWeekDay()
        if let inputValue = meatInputTextField.text {
            if (inputValue == "," || inputValue.isEmpty) {
                // create the alert
                       let alert = UIAlertController(title: "Intet indtastet!", message: "Indtast hvor mange gram du har spist.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                return
            } else {
                let input = NumberFormatter().number(from: meatInputTextField.text!)
                if let inputNumber = input {
                    let calculatedCo2 = Float(truncating: inputNumber) * 0.0194
                co2Input = Co2InputData(source: "Kød-forbrug", size: calculatedCo2, date: date, input: Float(truncating: inputNumber))
                dailyCount = DailyCo2Count(count: calculatedCo2, date: date,weekday: weekday)
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
        if meatInputTextField.text?.isEmpty == false {
            let input = NumberFormatter().number(from: meatInputTextField.text!)
            if let number = input {
                let calculatedCo2 = Float(truncating: number) * 0.0194
                emittedCo2.text = String(format: "%.2f", calculatedCo2)
            }
            
        } else {
            meatInputTextField.text = nil
            emittedCo2.text = nil
        }
    }
    
    @objc func noMeatTypeSelected(textField: UITextField) {
        if co2BasedOnMeatType() == 0.0 {
            meatInputTextField.text = nil
            emittedCo2.text = nil
            // create the alert
                   let alert = UIAlertController(title: "", message: "Vælg venligst kød type.", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        
        } else {
            pickerViewTextField.layer.borderColor = nil
        }
    }
    
    func co2BasedOnMeatType() -> Float{
        var co2Number: Float?
        switch selectedMeatType {
        case "vælg kød":
            co2Number = 0.0
        case "Okse":
            co2Number = 0.0194
        case "Svin":
            co2Number = 0.0036
        case "Kylling":
            co2Number = 0.0034
        case "Lam":
            co2Number = 0.0145
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
        
        gradientLayer.frame = meatSaveCo2Btn.bounds
        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]

        meatSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        meatSaveCo2Btn.layer.cornerRadius = 6
        meatSaveCo2Btn.layer.masksToBounds = true
        meatSaveCo2Btn.layer.borderWidth = 1.0
        meatSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
       
        meatInputTextField.label.text = "Indtast gram"
        meatInputTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        // Add material textfield to the ui
        ParentInputViewController().addTextField(textField: meatInputTextField, view: self.view, height: 350)
        
        emittedCo2.label.text = "Udledt CO2 i kg"
        parentVC.addEmittedTextField(textField: emittedCo2, height: 200, view: self.view)
        
        //Stack View
        stackView.addArrangedSubview(pickerViewTextField)
        stackView.addArrangedSubview(meatInputTextField)
        stackView.addArrangedSubview(emittedCo2)
        stackView.addArrangedSubview(meatSaveCo2Btn)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerViewTextField.layer.borderColor = UIColor(named: "ColorIcon")?.cgColor
        pickerViewTextField.layer.borderWidth = 1.0
        pickerViewTextField.layer.cornerRadius = 6
        pickerViewTextField.layer.masksToBounds = true
        
        meatInputTextField.addTarget(self, action: #selector(noMeatTypeSelected(textField:)), for: .touchDown)
        
    }

}

extension MeatViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.meatType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.meatType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedMeatType = self.meatType[row]
        self.pickerViewTextField.text = self.selectedMeatType
        meatInputTextField.text = nil
        emittedCo2.text = nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: meatType[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}
