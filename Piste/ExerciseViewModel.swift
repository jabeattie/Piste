//
//  ExerciseViewModel.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

struct ExerciseViewModel {
    
    private var exercises: Results<Exercise>?
    
    private var realm: Realm?
    
    init() {
        realm = try? Realm()
        fetchExercises()
    }
    
    var count: Int {
        return exercises?.count ?? 0
    }
    
    func exerciseName(atIndex index: Int) -> String? {
        return exercises?[index].name
    }
    
    mutating func addExercise(_ exercise: Exercise) {
        try? realm?.write {
            realm?.add(exercise)
        }
        fetchExercises()
    }
    
    private mutating func fetchExercises() {
        exercises = realm?.objects(Exercise.self)
    }
}
