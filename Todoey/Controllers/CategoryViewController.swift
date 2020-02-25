//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Paula Montero on 25/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Categoria]()
    
    let context2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    
    }

//MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellCategory = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
            cellCategory.textLabel?.text = categories[indexPath.row].name
        
        return cellCategory
        
    }
    
//MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    

//MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        do {
            try context2.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategories(with request : NSFetchRequest<Categoria> = Categoria.fetchRequest()) {
         
         do {
             categories = try context2.fetch(request) //se recuperan los datos
         } catch {
             print("Error fetching data from context, \(error)")
         }
         
         tableView.reloadData()
     }
    
    
//MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Categoria(context: self.context2)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategory()
            
        }
        
        //campo donde escribir en la alerta
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        //para presentar la alerta
        present(alert, animated: true, completion: nil)
        
    }
    

    
}
