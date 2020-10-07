//
//  ViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 15/09/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var co2Counter: UILabel!
    
    
    @IBAction func enterCo2(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "select_co2_vc") as! SelectCo2ViewController
       
        present(vc, animated: true)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

