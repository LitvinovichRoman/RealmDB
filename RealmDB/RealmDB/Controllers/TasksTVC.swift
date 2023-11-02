//
//  TasksTVC.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import UIKit
import RealmSwift

class TasksTVC: UITableViewController {
    
    let dateFormatter = DateFormatter()
    var tasks: [Task] = []
    var taskLists: Results<TasksList>?
    
    override func viewDidLoad() {
           super.viewDidLoad()
           loadTasks()
           loadTaskLists()
       }
       
       func loadTaskLists() {
           taskLists = StorageManager.getAllTasksLists()
       }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let taskName = textField.text {
                self?.addTask(taskName)
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addTask(_ taskName: String) {
        let task = Task()
        task.name = taskName
        do {
            try StorageManager.saveTask(task)
            loadTasks()
        } catch { print("saveTask error: \(error)") }
    }
    
    func loadTasks() {
        tasks = StorageManager.getAllTasks()
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
    
        dateFormatter.dateFormat = "HH:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: task.date)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            StorageManager.deleteTask(task: task)
            loadTasks()
            tableView.reloadData()
        }
    }
    
    
}
