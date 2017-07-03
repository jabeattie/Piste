//
//  TemplateViewModel.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

struct TemplateViewModel {
    var name = MutableProperty<String>("")
    var exercises = MutableProperty<List<Exercise>>(List<Exercise>())
    var templateId: Int
    
    init(templateId: Int?) {
        
        let realm = try? Realm()
        
        if let id = templateId {
            self.templateId = id
            
            let template = realm?.object(ofType: TemplateWorkout.self, forPrimaryKey: id)
            
            if let name = template?.name {
                self.name.value = name
            }
            
            if let exercises = template?.exercises {
                self.exercises.value = exercises
            }
        } else {
            self.templateId = (realm?.objects(TemplateWorkout.self).max(ofProperty: "id") as Int? ?? 0) + 1
        }
    }
    
    func addExercise(name: String) {
        let exercise = Exercise()
        exercise.name = name
        let set = ExerciseSet()
        set.reps = 10
        set.weight = 50
        exercise.defaultSet = set
        
        exercises.value.append(exercise)
    }
    
}
