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
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }
    
    static func deleteTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                let tasks = tasksList.tasks
                realm.delete(tasks)
                realm.delete(tasksList)
            }
        } catch {
            print("deleteTasksList error: \(error)")
        }
    }
    
    static func editeTasksList(tasksList: TasksList,
                               newListName: String) {
        do {
            try realm.write {
                tasksList.name = newListName
            }
        } catch {
            print("editeTasksList error: \(error)")
        }
    }
    
    static func saveTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch {
            print("saveTasksList error: \(error)")
        }
    }
    
    static func makeAllDone(tasksList: TasksList) {
        do {
            try realm.write {
                tasksList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch {
            print("makeAllDone error: \(error)")
        }
    }
    
    static func saveTask(tasksList: TasksList, task: Task) {
        do {
            try realm.write {
                tasksList.tasks.append(task)
            }
        } catch {
            print("saveTask error: \(error)")
        }
    }
    
    static func editTask(task: Task,
                         newName: String,
                         newNote: String) {
        do {
            try realm.write {
                task.name = newName
                task.note = newNote
            }
        } catch {
            print("editTask error: \(error)")
        }
    }
    
    static func deleteTask(task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("deleteTask error: \(error)")
        }
    }
    
    static func makeDoneTask(task: Task) {
        do {
            try realm.write {
                task.isComplete.toggle()
            }
        } catch {
            print("makeDoneTask error: \(error)")
        }
    }
    
    static func findRealmFile() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    static func moveTask(from sourceIndex: Int, to destinationIndex: Int, tasksList: TasksList) {
            guard sourceIndex != destinationIndex else { return }
            
            try! realm.write {
                let taskToMove = tasksList.tasks[sourceIndex]
                tasksList.tasks.remove(at: sourceIndex)
                tasksList.tasks.insert(taskToMove, at: destinationIndex)
            }
        }
}
