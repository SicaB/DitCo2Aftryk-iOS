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
    let deviceType = UIDevice().type
    var id: Int!
    
    @IBOutlet weak var windmill: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerViewCar: UIView!
    @IBOutlet weak var containerViewClothes: UIView!
    @IBOutlet weak var containerViewBus: UIView!
    @IBOutlet weak var containerViewMeat: UIView!
    @IBOutlet weak var containerViewTrain: UIView!
    @IBOutlet weak var containerViewEl: UIView!
    @IBOutlet weak var containerViewPlane: UIView!
    @IBOutlet weak var containerViewHeating: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var hightContainerViewsConstraint: NSLayoutConstraint!
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func homeBarButtonAction(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar?.delegate = self
        device()
        
        hideAllContainerViews()

        selectedIndex(indexNumber: id)
        
    }
    
    func saveInputData(input: Co2InputData){
        dbFirestoreService.saveCo2(input: input)
    }
    
    func saveDailyCount(count: DailyCo2Count) {
        dbFirestoreService.updateDailyCo2Count(newCount: count)
    }
    
    func getDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func getTodaysWeekDay() -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: Date())
           return weekDay
     }

    
    func addTextField(textField: MDCOutlinedTextField, view: UIView, height: Int){
        
        let textFieldFrame = CGRect(x: 0, y: 0, width: Int(view.frame.width) - 140, height: height)
        
        textField.frame = textFieldFrame
        //textField.backgroundColor = UIColor(named: "ColorIcon")
        textField.font = .systemFont(ofSize: 16)
        textField.setTextColor(.white, for: .editing)
        textField.setTextColor(.white, for: .normal)
        textField.setFloatingLabelColor(.white, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "ColorIcon")!, for: .disabled)
        textField.setFloatingLabelColor(.white, for: .normal)
        textField.setNormalLabelColor(.gray, for: .normal)
        textField.setNormalLabelColor(.gray, for: .disabled)
        textField.setNormalLabelColor(.gray, for: .editing)
        textField.setOutlineColor(.gray, for: .normal)
        textField.setOutlineColor(UIColor(named: "ColorIcon")!, for: .editing)
        //textField.setOutlineColor(.gray, for: .disabled)
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
    
    func addEmittedTextField(textField: MDCOutlinedTextField, height: Int, view: UIView){
        
        let textFieldFrame = CGRect(x: 0, y: 0, width: Int(view.frame.width) - 140, height: height)
        
        textField.frame = textFieldFrame
        textField.font = .systemFont(ofSize: 16)
        textField.setTextColor(UIColor(named: "ColorIcon")!, for: .editing)
        textField.setTextColor(UIColor(named: "ColorIcon")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "ColorIcon")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "ColorIcon")!, for: .disabled)
        textField.setFloatingLabelColor(.white, for: .normal)
        textField.setNormalLabelColor(.darkGray, for: .normal)
        textField.setNormalLabelColor(.darkGray, for: .disabled)
        textField.setNormalLabelColor(.darkGray, for: .editing)
        textField.setOutlineColor(.darkGray, for: .normal)
        textField.setOutlineColor(.darkGray, for: .editing)
        textField.setOutlineColor(.darkGray, for: .disabled)
        textField.isUserInteractionEnabled = false

        textField.trailingViewMode = .whileEditing
    
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
        containerViewCar?.alpha = 0
        containerViewClothes?.alpha = 0
        containerViewBus?.alpha = 0
        containerViewMeat?.alpha = 0
        containerViewTrain?.alpha = 0
        containerViewEl?.alpha = 0
        containerViewPlane?.alpha = 0
        containerViewHeating?.alpha = 0
    }
    
    
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
    
    private func device() {
        switch deviceType {
        case .iPhone5:
            break
        case .iPhone5S:
            break
        case .iPhone6:
            break
        case .iPhone6Plus:
            break
        case .iPhone6S:
            hightContainerViewsConstraint?.constant = 200
            containerView?.layoutIfNeeded()
        case .iPhone6SPlus:
            break
        case .iPhone7:
            break
        case .iPhone7Plus:
            break
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhoneX:
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .iPhoneXS:
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .iPhoneXSMax:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .iPhone11ProMax:
            break
        case .iPhone12:
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .iPhone12Mini:
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .iPhone12Pro:
            
            // do tabbar
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        case .unrecognized: break
            // nothing
        default: break
            
        }
    
    }
    
}
