//
//  ViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-12.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        

    var itemArray = [Items]()
// Singleton    let defaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
        
        
//        loadItems()
        
      
            
        
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
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
   // Delete data using core data
//           ORDER MATTERS for this 2 lines
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//
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
            
            
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context, \(error)")
                    }
                    self.tableView.reloadData()
         
    }
    
    func loadItems(with request:NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil) {
   //     let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }   else {
            request.predicate = categoryPredicate
        }
        
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
         itemArray = try context.fetch(request)
        } catch {
            print("Error fetheching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Items> = Items.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // [cd] = case and diacritic insensitive
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
// Or the 2 lines above can be written as this
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       loadItems(with: request, predicate: predicate)
        
       }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

