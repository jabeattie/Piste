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
    dynamic var date = Date()
    dynamic var name = ""
    let exercises = List<WorkoutExercise>()
    dynamic var templateWorkout: TemplateWorkout? = nil
}
