//
//  CategoryViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-16.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
     
    
    override func viewDidLoad() {
                 super.viewDidLoad()
                
                 loadData()
                 tableView.separatorStyle = .none
                
    }
    
    
    
       //MARK - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
   
         
         //MARK - TableView Delegate methods ** leave for later
         // What should happen when we click on one of the cells in the category view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // connect to items tableview
        performSegue(withIdentifier: "goToItems", sender: self)
        
       }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
         
       
         //MARK - Data manipulation methods
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving date, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        
        categoryArray = realm.objects(Category.self)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error loading data, \(error)")
//        }
        tableView.reloadData()
        
    }
    
    
    
    
    
         //MARK - Set up addbutton
       @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Add", style: .default) { (action1) in
            let newItem = Category()
            newItem.name = textField.text!
//            self.categoryArray.append(newItem)
            self.save(category : newItem)
        }
        let action2 = UIAlertAction(title: "Cance", style: .default) { (action2) in
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil )
        
         
        
        
       
       
       
   }
}

