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
    var items = ["Slet seneste indtastning", "Slet indtastninger i dag", "Se indtastninger"]
    
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
            print(indexPath.row)
        case 1:
            dbFirestoreService.deleteAllInputs()
            dbFirestoreService.deleteAccumulatedCount()
            self.navigationController!.popToRootViewController(animated: true)
            print(indexPath.row)
        
        case 2:
            performSegue(withIdentifier: "showList", sender: self)
            
        default:
            break
            
        }
        
    }
    
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.items.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .left)
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
//            self.items.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//        }
//        deleteAction.image = UIImage(systemName: "trash")
//        deleteAction.backgroundColor = .systemRed
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }

    

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
        bgColorView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    
    
}
