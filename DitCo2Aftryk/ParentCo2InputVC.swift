//
//  ParentCo2InputVC.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 20/10/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class ParentCo2InputVC: UIViewController {
    
    let carVC = CarViewController()
    let clothesVC = ClothesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        selectedSegment()
        

    }
    
    private func selectedSegment() {
        
    }

    
    private func setup(){
        
        addChild(carVC)
        addChild(clothesVC)
        
        // Add views to the controllers
        self.view.addSubview(carVC.view)
        self.view.addSubview(clothesVC.view)
        
        carVC.didMove(toParent: self)
        clothesVC.didMove(toParent: self)
        
        // set the frame for each view controller
        carVC.view.frame = self.view.bounds
        clothesVC.view.frame = self.view.bounds
        clothesVC.view.isHidden = true
    }
    
    
    @IBAction func didTapSegment(segment: UISegmentedControl) {
        carVC.view.isHidden = true
        clothesVC.view.isHidden = true
        
        if segment.selectedSegmentIndex == 0 {
            carVC.view.isHidden = false
        }
        else {
            clothesVC.view.isHidden = false
        }
    }
    

}
