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
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setup()
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
    
       let heatingTextField = MDCOutlinedTextField()
       
        heatingTextField.label.text = "Antal kWh"
        
        // Add material textfield to the ui
        ParentInputViewController().addTextField(textField: heatingTextField, view: self.view, hight: 350)

        
    }

}
