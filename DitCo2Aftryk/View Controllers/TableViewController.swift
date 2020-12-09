//
//  TableViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 03/12/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    private var dbFirestoreService = DBFirestoreService()
    var items = ["Slet seneste indtastning", "Slet indtastninger i dag", "Se dagens indtastninger"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .black

        
    }
    

    

    
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let refreshAlert = UIAlertController(title: "Slet seneste indtastning?", message: "Du er ved at slette din seneste indtastning. Er du sikker?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.dbFirestoreService.deleteLastInput()
                self.navigationController!.popToRootViewController(animated: true)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  return
            }))

            present(refreshAlert, animated: true, completion: nil)
            
        case 1:
            let refreshAlert = UIAlertController(title: "Slet dagens indtastninger?", message: "Alle dine indtasninger vil blive slettet. Er du sikker?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.dbFirestoreService.deleteAllInputs()
                self.dbFirestoreService.deleteAccumulatedCount()
                self.navigationController!.popToRootViewController(animated: true)
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  return
            }))

            present(refreshAlert, animated: true, completion: nil)
           
        
        case 2:
            performSegue(withIdentifier: "showList", sender: self)
            
        default:
            break
            
        }
        
    }

    

}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    
    
}
