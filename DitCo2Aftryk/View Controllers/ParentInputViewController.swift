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

class ParentInputViewController: UIViewController, UITabBarControllerDelegate, UITabBarDelegate {
    
    private var dbFirestoreService = DBFirestoreService()
    
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
    
    @IBOutlet weak var tabBar: UITabBar!
    
   
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func homeBarButtonAction(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    var id: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        
        hideAllContainerViews()
        
        
      
        
        selectedIndex(indexNumber: id)
        
        
//        if #available(iOS 13.0, *) {
//            segmentedControl.layer.borderColor = UIColor(named: "ImageGreen")?.cgColor
//            segmentedControl.layer.borderWidth = 1
//            
//            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
//        }
    }
    
    func saveInputData(input: Co2InputData){
        dbFirestoreService.saveCo2(input: input)
    }
    
    func saveDailyCount(count: DailyCo2Count) {
        dbFirestoreService.updateDailyCo2Count(newCount: count)
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
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
    
    
    private func selectedIndex(indexNumber: Int) {
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
        
        tabBar.selectedItem = tabBar.items?[indexNumber]

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
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//         let tabBarIndex = tabBarController.selectedIndex
//         if tabBarIndex == 0 {
//             //do your stuff
//         }
//    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            //This method will be called when user changes tab.
        print(item.tag)
        hideAllContainerViews()
        
        let indexNumber = item.tag
        
        selectedIndex(indexNumber: indexNumber)
        
        }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("something happend")
        hideAllContainerViews()
        
        let indexNumber = tabBarController.selectedIndex
        
        selectedIndex(indexNumber: indexNumber)
        
        
    }
    
    
}
