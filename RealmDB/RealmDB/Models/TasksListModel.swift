//
//  TasksListModel.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}
