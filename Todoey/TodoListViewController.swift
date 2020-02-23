//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Paula Montero on 22/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Estudiar iOS", "Mañana festejar cumple de Die", "Comer cosas ricas :)"]
    
    let defaults = UserDefaults.standard //esto sirve para que persistan ciertos datos en memoria
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //se escribe de este modo por las dudas que no exista "TodoListArray"
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
        }
        
    }

    //MARK - TableView Datasource Methods
    //Armo la cantidad de celdas y las relleno con el array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    //Toma la fila seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none //si tiene check, se lo quita
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //al seleccionar se coloca el check
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //estas líneas arman la alerta
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //acción del botón que guarda lo escrito en la alerta
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData() //para que el dato nuevo se vea reflejado en la tabla
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
    
    
}
