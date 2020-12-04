//
//  TableViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 03/12/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit

class ListOfInputsViewController: UIViewController {

    
    @IBOutlet var listOfInputs: UITableView!
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    private var dbFirestoreService = DBFirestoreService()
    var items = ["Input1", "Input2", "Input3", "Input4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfInputs.delegate = self
        listOfInputs.dataSource = self
        
        self.listOfInputs.allowsMultipleSelectionDuringEditing = false
        listOfInputs.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        listOfInputs.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .black

        
    }
    

    

    
}

extension ListOfInputsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print(indexPath.row)
        case 1:
            dbFirestoreService.deleteAllInputs()
            dbFirestoreService.deleteAccumulatedCount()
            self.navigationController!.popToRootViewController(animated: true)
            print(indexPath.row)
        
        case 2:
            break
            
        default:
            break
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items.remove(at: indexPath.row)
            self.listOfInputs.deleteRows(at: [indexPath], with: .left)
        }

    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.items.remove(at: indexPath.row)
            self.listOfInputs.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    

}

extension ListOfInputsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    
    
}
