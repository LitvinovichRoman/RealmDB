//
//  TasksListTVC.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    var taskLists: Results<TasksList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        
        navigationItem.setRightBarButton(add, animated: true)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        return cell
    }
    
    @objc
    private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks()
    }
    
    private func alertForAddAndUpdatesListTasks() {
        
        let title = "New list"
        let messege = "Please insert list name"
        let doneButtonName = "Save"
        
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            guard let self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else { return }
            
            let taskList = TasksList()
            taskList.name = newListName
            StorageManager.saveTasksList(tasksList: taskList)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List name"
        }
        
        present(alertController, animated: true)
    }
}
