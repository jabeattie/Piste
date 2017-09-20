//
//  Workout.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class Workout: Object {
    @objc dynamic var date = Date()
    @objc dynamic var name = ""
    let exercises = List<WorkoutExercise>()
    @objc dynamic var templateWorkout: TemplateWorkout? = nil
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
