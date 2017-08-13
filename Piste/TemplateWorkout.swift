//
//  TemplateWorkout.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class TemplateWorkout: Object {
    let exercises = List<Exercise>()
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
