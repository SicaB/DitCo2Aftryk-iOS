//
//  ParentCo2InputVC.swift
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

class ParentCo2InputVC: UIViewController {
    
    @IBOutlet weak var windmill: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerViewCar: UIView!
    @IBOutlet weak var containerViewClothes: UIView!
    @IBOutlet weak var containerViewBus: UIView!
    @IBOutlet weak var containerViewMeat: UIView!
    @IBOutlet weak var containerViewTrain: UIView!
    @IBOutlet weak var containerViewEl: UIView!
    @IBOutlet weak var containerViewPlane: UIView!
    @IBOutlet weak var containerViewHeating: UIView!
    
    var id: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAllContainerViews()
        
        selectedSegment(indexNumber: id)
        
        
        if #available(iOS 13.0, *) {
            segmentedControl.layer.borderColor = UIColor(named: "ImageGreen")?.cgColor
            segmentedControl.layer.borderWidth = 1
            
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)

            
        }
        

    }
    
    func addTextField(textField: MDCOutlinedTextField, view: UIView, hight: Int){
        
        let textFieldFrame = CGRect(x: 0, y: 0, width: Int(view.frame.width) - 140, height: hight)
        
        textField.frame = textFieldFrame
       
        textField.setTextColor(.white, for: .editing)
        textField.setTextColor(.white, for: .normal)
        textField.setFloatingLabelColor(.white, for: .editing)
        textField.setFloatingLabelColor(.white, for: .disabled)
        textField.setFloatingLabelColor(.white, for: .normal)
        textField.setNormalLabelColor(.white, for: .normal)
        textField.setNormalLabelColor(.white, for: .disabled)
        textField.setNormalLabelColor(.white, for: .editing)
        textField.setOutlineColor(.white, for: .normal)
        textField.setOutlineColor(.white, for: .editing)
        textField.setOutlineColor(.white, for: .disabled)
        textField.keyboardType = .decimalPad

        textField.trailingViewMode = .whileEditing
        
        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white
        
        textField.clearButtonMode = .whileEditing
        textField.tintColor = .white
        textField.center = view.center
        textField.sizeToFit()
        view.addSubview(textField)
    
        
          
    }
    
    
    
    
    private func selectedSegment(indexNumber: Int) {
        print(indexNumber)
        
        switch indexNumber {
        case 0:
            containerViewCar.alpha = 1
        case 1:
            containerViewClothes.alpha = 1
        case 2:
            containerViewBus.alpha = 1
        case 3:
            containerViewMeat.alpha = 1
        case 4:
            containerViewTrain.alpha = 1
        case 5:
            containerViewEl.alpha = 1
        case 6:
            containerViewPlane.alpha = 1
        case 7:
            containerViewHeating.alpha = 1
        default:
            print("containerError")
        }
        
        segmentedControl.selectedSegmentIndex = indexNumber
        
    }
    
    private func hideAllContainerViews(){
        containerViewCar.alpha = 0
        containerViewClothes.alpha = 0
        containerViewBus.alpha = 0
        containerViewMeat.alpha = 0
        containerViewTrain.alpha = 0
        containerViewEl.alpha = 0
        containerViewPlane.alpha = 0
        containerViewHeating.alpha = 0
    }
    
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        
        hideAllContainerViews()
        
        let indexNumber = sender.selectedSegmentIndex
        
        selectedSegment(indexNumber: indexNumber)
        
        
    }
    
}
