//
//  WorkoutExercise.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class WorkoutExercise: Object {
    dynamic var exercise: Exercise? = nil
    dynamic var date = Date()
    let sets = List<ExerciseSet>()
    
}
