//
//  ListModel.swift
//  RealmDB
//
//  Created by Roman Litvinovich on 02/11/2023.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
