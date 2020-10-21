//
//  ParentCo2InputVC.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 20/10/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSegment()
        
        if #available(iOS 13.0, *) {
            segmentedControl.layer.borderColor = UIColor(named: "ImageGreen")?.cgColor
            segmentedControl.layer.borderWidth = 1
            
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            
            hideAllContainerViews()
            
//            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
//            segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .selected)
            
        }
        

    }
    
    
    private func selectedSegment() {
        
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
        
//        if sender.selectedSegmentIndex == 0 {
//            containerViewCar.alpha = 1
//            containerViewClothes.alpha = 0
//        }
//        else {
//            containerViewCar.alpha = 0
//            containerViewClothes.alpha = 1
//
//        }
    }
    

}
