//
//  ViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-12.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Items]()
// Singleton    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath!)
        
        
        loadItems()
            
        
//
  //  User defaults can not be used for custom objects with properties
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
//            itemArray = items
//        } else {
//
//        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item  = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator
    //  Can replace the below if statement
    //    cell.accessoryType = item.done ? .checkmark : .none
        
        
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
   // This line is = to if statement bellow
   //     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false 
        }
         
        saveItems()
        
//
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//           tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }  else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
         tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoly Item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks add item on alert
           print("Success1")
            
            
            let newItem = Items()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
                    do {
                        let data = try encoder.encode(itemArray)
                        try data.write(to: dataFilePath!)
                    } catch {
                        print("Error encoding item array, \(error)")
                    }
                    
         // Works only with user defaults singleton
        //          self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                    print(self.itemArray)
                    self.tableView.reloadData()
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Items].self, from: data)
            } catch {
                print("Error decoding the itemArray, \(error)")
            }
            
        }
    }
    
}

