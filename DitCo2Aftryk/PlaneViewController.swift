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

    
    @IBOutlet weak var planeSaveCo2Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
    
       let planeTextField = MDCOutlinedTextField()
       
        planeTextField.label.text = "Antal timer"
        
        // Add material textfield to the ui
        ParentCo2InputVC().addTextField(textField: planeTextField, view: self.view, hight: 350)

        
    }

}
