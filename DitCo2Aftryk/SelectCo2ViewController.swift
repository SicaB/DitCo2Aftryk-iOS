//
//  SelectCo2ViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 15/09/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class SelectCo2ViewController: UIViewController {
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var clothesButton: UIButton!
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var meatButton: UIButton!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var elButton: UIButton!
    @IBOutlet weak var planeButton: UIButton!
    @IBOutlet weak var heatingButton: UIButton!
    
    var imageEdgeInsets = UIEdgeInsets(top: 30, left: 53, bottom: 30, right: 53)
    
    let greenColor = UIColor(named: "Color")
    
    @IBAction func carButtonCo2(_ sender: UIButton) {
    }
    
    @IBAction func clothesButtonCo2(_ sender: UIButton) {
    }
    
    @IBAction func busButtonCo2(_ sender: UIButton) {
    }
    
    
    @IBAction func meatButtonCo2(_ sender: UIButton) {
    }
    
    @IBAction func trainButtonCo2(_ sender: UIButton) {
    }
    
    @IBAction func elButtonCo2(_ sender: UIButton) {
    }
    
    @IBAction func planeButtonCo2(_ sender: UIButton) {
    }
    
    
    @IBAction func heatingButtonCo2(_ sender: UIButton) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        carButton.imageEdgeInsets = imageEdgeInsets
        clothesButton.imageEdgeInsets = imageEdgeInsets
        busButton.imageEdgeInsets = imageEdgeInsets
        meatButton.imageEdgeInsets = imageEdgeInsets
        trainButton.imageEdgeInsets = imageEdgeInsets
        elButton.imageEdgeInsets = imageEdgeInsets
        planeButton.imageEdgeInsets = imageEdgeInsets
        heatingButton.imageEdgeInsets = imageEdgeInsets

        
    }
    

  
}
