//
//  TableViewController.swift
//  DitCo2Aftryk
//
//  Created by Sacha Behrend on 03/12/2020.
//  Copyright © 2020 Sacha Behrend. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ListOfInputsViewController: UIViewController {
    
    @IBOutlet var listOfInputs: UITableView!
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    private var dbFirestoreService = DBFirestoreService()
    
    var source = [String]()
    var input = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfInputs.delegate = self
        listOfInputs.dataSource = self
        
        self.listOfInputs.allowsMultipleSelectionDuringEditing = false
        listOfInputs.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        listOfInputs.backgroundColor = UIColor.black
        listOfInputs.separatorColor = UIColor.init(named: "ColorBlack")
        self.navigationController?.navigationBar.backgroundColor = .black


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dbFirestoreService.getAllInputs(completion: { (sources, inputs) in
            
            
            self.source.append(contentsOf: sources)
            self.input.append(contentsOf: inputs)
               
//            
 //          print(sources)
//            print(self.input)
            self.listOfInputs.reloadData()
            
            if self.source.isEmpty {
                // create the alert
                       let alert = UIAlertController(title: "Intet indtastet!", message: "Du har ikke indtastet noget i dag.", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                
               return
            }
        })
        
        
    }
    
}

extension ListOfInputsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("item deleted")
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.source.remove(at: indexPath.row)
            self.listOfInputs.deleteRows(at: [indexPath], with: .left)
           
        }

    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.source.remove(at: indexPath.row)
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
        
        return self.source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        cell.textLabel?.text = self.source[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = self.input[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
    
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = bgColorView
        return cell
        
    }
    
    
    
}
