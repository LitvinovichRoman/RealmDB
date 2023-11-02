//
//  StorageManager.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func getAllTasksLists() -> Results<TasksList> {
        realm.objects(TasksList.self)
    }
    
    static func deleteAll() {
        do { 
            try realm.write { realm.deleteAll() }
        } catch { print("deleteAll error: \(error)") }
    }
    
    static func saveTasksList(tasksList: TasksList) {
        do { 
            try realm.write { realm.add(tasksList) }
        } catch { print("saveTasksList error: \(error)") }
    }
    
    static func saveTask(_ task: Task) {
           do {
               try realm.write { realm.add(task) }
           } catch { print("saveTask error: \(error.localizedDescription)") }
       }
    
    
    static func deleteTask(task: Task) {
          do {
            try realm.write { realm.delete(task) }
          } catch { print("deleteTask error: \(error)") }
      }
    
    
    static func deleteTasksList(tasksList: TasksList) {
        do {
            try realm.write { realm.delete(tasksList) }
        } catch { print("deleteTasksList error: \(error)") }
    }
    
    
    static func getAllTasks() -> [Task] {
            do {
                let tasks = realm.objects(Task.self)
                return Array(tasks)
            } catch { print("Error fetching all tasks from the database. \(error)") }
        }
    
}

