//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Paula Montero on 22/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //Categoria? va a nulo hasta que le viajen los datos de categoria
    var selectedCategory : Categoria? {
        
        //tan pronto como se establezca la categoria se dispara lo siguiente
        didSet{
            
            loadItems()
            
        }
        
        
    }

    //este es un Singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard //esto sirve para que persistan ciertos datos en memoria - no lo uso ahora porque cree uno personalizado
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

//MARK: - TableView Datasource Methods
    
    //Armo la cantidad de celdas y las relleno con el array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Ternary operator reemplaza lo siguiente:
        /*if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
    
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    //Toma la fila seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //lo siguiente se usa para eliminar
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        //coloca el opuesto
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //estas líneas arman la alerta
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //acción del botón que guarda lo escrito en la alerta
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategoria = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        //campo donde escribir en la alerta
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        //para presentar la alerta
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        //let encoder = PropertyListEncoder() esto es del otro método que se hizo
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData() //para que el dato nuevo se vea reflejado en la tabla
        
    }
    
    //Item.fetchRequest() valor predeterminado en el caso de querer cargar elementos sin dar ningún parámetro
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategoria.name MATCHES %@", selectedCategory!.name!)
        
        //se coloca así para asegurar que no es nulo
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

//Para no apilar todas las funcionalidades hago una extensión
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest() //solicitud de recuperación
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //se coloca [cd] para que no sea sensible a mayúsculas y minúsculas
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //para darle orden
       
        loadItems(with: request, predicate: predicate)
        
    }
    
    //sirve para cuando se borra totalmente lo que esta dentro de la barra de búsqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //ejecutar en la cola principal
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //para que vuelva al estado anterior cuando no se utilizaba, no estaba activa
            }
            
        }
    }
    
    
}
