//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Paula Montero on 22/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Estudiar iOS", "Mañana festejar cumple de Die", "Comer cosas ricas :)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
}
