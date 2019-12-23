//
//  ViewController.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-12.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework



class TodoListViewController : SwipeTableViewController {
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
           loadItems()
        }
    }
    
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        

    var todoItems : Results<Items>?
// Singleton    let defaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self as UISearchBarDelegate
       
  //      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
        
      

        
 //       todoItems = realm.objects(Items.self)
        
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
  
    
    // viewWillAppear happens after viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
            guard let colourHex = selectedCategory?.color else {fatalError()}
        
            title = selectedCategory?.name
                
           updateNavBar(withHexCode: colourHex)
            
            // for search bar
            searchBar.barTintColor = UIColor(hexString: colourHex)
            searchBar.searchTextField.backgroundColor = FlatWhite()
            
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Update Navigation Bar
    
    func updateNavBar(withHexCode colourHexCode:String) {
                 guard let navBar = navigationController?.navigationBar else { fatalError("Navigation control does not exist")}
                  // for navigation bar background colour
                  navBar.barTintColor = UIColor(hexString: colourHexCode)
                   
                       //For back and plus button
                   navBar.tintColor = ContrastColorOf(backgroundColor: UIColor(hexString: colourHexCode), returnFlat: true)
                   //for title
                   navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: UIColor(hexString: colourHexCode), returnFlat: true)]
        
    }
    
    
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item  = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            
            if let colour = UIColor(hexString:selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row)/2 / CGFloat(todoItems!.count)) {
                 cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
            }
           
            
            
            
                   
                   // Ternary operator
               //  Can replace the below if statement
               //    cell.accessoryType = item.done ? .checkmark : .none
                   
                   
                   if item.done == true {
                       cell.accessoryType = .checkmark
                   } else {
                       cell.accessoryType = .none
                   }
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)  to delete data from realm
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        
       // print(itemArray[indexPath.row])
        
   // This line is = to if statement bellow
       
  //      todoItems?[indexPath.row].done = !(todoItems[indexPath.row].done)
        
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
 //       saveItems()
        
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
            
            if let currentCategory = self.selectedCategory // we set selected category to have the name "currentCategory" if its not nill 
            {
                do {
                  try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new item, \(error)")
                    }
                }
            
            self.tableView.reloadData()
             
            }
//            let newItem = Items(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
 //           self.saveItems()
            
        
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
    
//    func saveItems() {
//                    do {
//                        try context.save()
//                    } catch {
//                        print("Error saving context, \(error)")
//                    }
//                    self.tableView.reloadData()
//
//    }
    

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    
    
//    func loadItems(with request:NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil) {
//   //     let request : NSFetchRequest<Items> = Items.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }   else {
//            request.predicate = categoryPredicate
//        }
//
//
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////
////        request.predicate = compoundPredicate
//
//        do {
//         itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetheching data from context, \(error)")
//        }
//        tableView.reloadData()
//    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.selectedCategory?.items[indexPath.row] {
        do {
            try self.realm.write {
                self.realm.delete(itemForDeletion)
            }
        } catch {
            print("Error deleting category, \(error)")
            
            }
            
        }
    }
//
}

//MARK - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        // [cd] = case and diacritic insensitive
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//// Or the 2 lines above can be written as this
////        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//       loadItems(with: request, predicate: predicate)
//
       
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
//
}

