//
//  CategoryViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-16.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
     var categoryArray = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
                 super.viewDidLoad()
                 
                 loadData()
                 tableView.separatorStyle = .none
                
    }
    
    
    
       //MARK - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
         
       
         //MARK - Data manipulation methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving date, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading data, \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    
    
    
         //MARK - Set up addbutton
       @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Add", style: .default) { (action1) in
            let newItem = Category(context: self.context)
            newItem.name = textField.text
            self.categoryArray.append(newItem)
            self.saveData()
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

