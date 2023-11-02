//
//  TasksListTVC.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    let dateFormatter = DateFormatter()
    var taskLists: Results<TasksList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        
        navigationItem.setRightBarButton(add, animated: true)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let taskList = taskLists?[indexPath.row] {
            cell.textLabel?.text = taskList.name
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.detailTextLabel?.text = dateFormatter.string(from: taskList.date)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let taskList = taskLists?[indexPath.row] {
                for task in taskList.tasks {
                    StorageManager.deleteTask(task: task)
                }
                StorageManager.deleteTasksList(tasksList: taskList)
                taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks()
    }
    
    private func alertForAddAndUpdatesListTasks() {
        let title = "New List"
        let message = "Enter the name of the list"
        let doneButtonName = "Save"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField?
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            guard let self = self,
                  let newListName = alertTextField?.text,
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
            alertTextField?.placeholder = "List name"
        }
        
        present(alertController, animated: true)
    }

}
