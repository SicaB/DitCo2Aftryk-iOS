//
//  PlaneViewController.swift
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

class PlaneViewController: UIViewController {

    let parentVC = ParentInputViewController()
    let planeInputTextField = MDCOutlinedTextField()
    let emittedCo2 = MDCOutlinedTextField()
    let planeBtn = MDCButton()
    
    private var co2Input = Co2InputData(source: "", size: 0, date: "")
    private var dailyCount = DailyCo2Count(count: 0, date: "")
    
    @IBOutlet weak var planeSaveCo2Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    @IBAction func savePlaneCo2(_ sender: Any) {
        let date = parentVC.getDate()
        if let inputValue = planeInputTextField.text {
            let inputFloat = (inputValue as NSString).floatValue
            co2Input = Co2InputData(source: "plane", size: inputFloat, date: date)
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
        
        gradientLayer.frame = planeSaveCo2Btn.bounds

        gradientLayer.colors = [topGradientColor?.cgColor ?? UIColor.blue, bottomGradientColor?.cgColor ?? UIColor.green]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.locations = [0.0, 1.0]

        planeSaveCo2Btn.layer.insertSublayer(gradientLayer, at: 0)
        
        planeSaveCo2Btn.layer.cornerRadius = 6
        planeSaveCo2Btn.layer.masksToBounds = true
        planeSaveCo2Btn.layer.borderWidth = 1.0
        planeSaveCo2Btn.layer.borderColor = UIColor(named: "DarkGreen")?.cgColor
    

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
       
        planeInputTextField.label.text = "Indtast timer"
        
        // Add material textfield to the ui
        ParentInputViewController().addTextField(textField: planeInputTextField, view: self.view, hight: 350)
        
        emittedCo2.label.text = "Udledt CO2"
        
        parentVC.addEmittedTextField(textField: emittedCo2, view: self.view, hight: 200)


        
    }

}
