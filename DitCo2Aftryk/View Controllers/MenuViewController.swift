//
//  SelectCo2ViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 15/09/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var clothesButton: UIButton!
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var meatButton: UIButton!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var elButton: UIButton!
    @IBOutlet weak var planeButton: UIButton!
    @IBOutlet weak var heatingButton: UIButton!
    
    var contentEdgeInsets = UIEdgeInsets(top: 45, left: 45, bottom: 45, right: 45)

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
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    private func adjustImageAndTitleOffsetsForButton(button: UIButton) {
        
        let spacing: CGFloat = 6.0
        let imageSize = button.imageView!.frame.size
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        
        button.titleLabel?.contentMode = .scaleAspectFit
        button.titleLabel?.clipsToBounds = true

        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        
        let titleSize = button.titleLabel!.frame.size
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        

    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        carButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: carButton)
       
        clothesButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: clothesButton)

        busButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: busButton)

        meatButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: meatButton)

        trainButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: trainButton)

        elButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: elButton)

        planeButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: planeButton)

        heatingButton.contentEdgeInsets = contentEdgeInsets
        self.adjustImageAndTitleOffsetsForButton(button: heatingButton)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var id = 0
        
        guard let identifier = segue.identifier else {
            assertionFailure("Segue has no identifier")
            return
        }
        
        switch identifier {
        case "ToCarVC":
            id = 0
            print("identifier car \(id)")
            
        case "ToClothesVC":
            id = 1
            print("identifier clothes \(id)")
            
        case "ToBusVC":
            id = 2
            print("identifier bus \(id)")
            
        case "ToMeatVC":
            id = 3
            print("identifier meat \(id)")
            
        case "ToTrainVC":
            id = 4
            print("identifier train \(id)")
            
        case "ToElVC":
            id = 5
            print("identifier el \(id)")
            
        case "ToPlaneVC":
            id = 6
            print("identifier plane \(id)")
            
        case "ToHeatingVC":
            id = 7
            print("identifier heating \(id)")
            
        default:
            assertionFailure("did not recognize storyboard identifier")
            
        }
        
        let parentCo2InputVC = (segue.destination as! ParentInputViewController)
        parentCo2InputVC.id = id
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }

  
}
