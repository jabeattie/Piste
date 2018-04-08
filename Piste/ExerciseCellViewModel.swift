//
//  ExerciseTableViewCellViewModel.swift
//  Piste
//
//  Created by James Beattie on 07/04/2018.
//  Copyright © 2018 James Beattie. All rights reserved.
//

import Foundation

struct ExerciseCellViewModel {
    
    enum DisplayType {
        case light
        case dark
    }
    
    private var exercise: Exercise
    var displayType: DisplayType
    
    var name: String? {
        return exercise.name
    }
    
    var weight: String? {
        guard let weight = exercise.defaultSet?.weight else { return nil }
        return String(format: "%.1f", weight)
        
    }
    
    var reps: String? {
        guard let reps = exercise.defaultSet?.reps else { return nil }
        return String(reps)
    }
    
    init(exercise: Exercise, type: DisplayType) {
        self.displayType = type
        self.exercise = exercise
    }
}
