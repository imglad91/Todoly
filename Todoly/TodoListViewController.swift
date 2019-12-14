//
//  ViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-12.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Buy Milk", "Get beer", "Go to school"]
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        } else {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }  else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    //MARK - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoly Item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks add item on alert
           print("Success1")
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            print(self.itemArray)
            self.tableView.reloadData()
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action2) in
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
         alert.addAction(action)
         alert.addAction(action2)
         present(alert, animated: true, completion: nil)
    }
    
    
}

