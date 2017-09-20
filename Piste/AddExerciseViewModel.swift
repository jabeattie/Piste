//
//  AddExerciseViewModel.swift
//  Piste
//
//  Created by James Beattie on 30/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

class AddExerciseViewModel {
    
    var savedSignal: Signal<Bool, NSError>
    var savedObserver: Signal<Bool, NSError>.Observer
    var retrievedSignal: Signal<Void, NSError>
    var retrievedObserver: Signal<Void, NSError>.Observer
    var exerciseName = MutableProperty<String>("")
    var exerciseReps = MutableProperty<Int>(0)
    var exerciseWeight = MutableProperty<Double>(0)
    
    private var exercise = Exercise()
    private var existsInRealm = false
    
    var editableName: Bool {
        return !existsInRealm
    }
    
    init(exerciseName: String?) {
        (savedSignal, savedObserver) = Signal<Bool, NSError>.pipe()
        (retrievedSignal, retrievedObserver) = Signal<Void, NSError>.pipe()
        
        if exerciseName == nil || exerciseName == "new" {
            self.exerciseName.signal.observeValues({ name in
                do {
                    let realm = try RealmProvider.realm()
                    
                    try realm.write {
                        self.exercise.name = name
                    }
                } catch let error {
                    self.savedObserver.send(value: false)
                }
            })
            
        } else {
            self.exerciseName.value = exerciseName ?? ""
        }
        exerciseReps.signal.observeValues({ reps in
            
            do {
                let realm = try RealmProvider.realm()
                
                try realm.write {
                    if let set = self.exercise.defaultSet {
                        set.reps = reps
                        self.exercise.defaultSet = set
                    } else {
                        let set = ExerciseSet()
                        set.reps = reps
                        self.exercise.defaultSet = set
                    }
                }
            } catch let error {
                self.savedObserver.send(value: false)
            }
        })
        exerciseWeight.signal.observeValues({ weight in
            
            do {
                let realm = try RealmProvider.realm()
                
                try realm.write {
                    if let set = self.exercise.defaultSet {
                        set.weight = weight
                        self.exercise.defaultSet = set
                    } else {
                        let set = ExerciseSet()
                        set.weight = weight
                        self.exercise.defaultSet = set
                    }
                }
            } catch let error {
                self.savedObserver.send(value: false)
            }
            
           
        })
    }
    
    func save() {
        do {
            let realm = try RealmProvider.realm()
            
            try realm.write {
                realm.add(exercise)
            }
            savedObserver.send(value: true)
            
        } catch let error {
            savedObserver.send(value: false)
        }
    }
    
    func fetchExercise() {
        guard !exerciseName.value.isEmpty else { return }
        do {
            let realm = try RealmProvider.realm()
            guard let e = realm.object(ofType: Exercise.self, forPrimaryKey: exerciseName.value) else {
                    return
            }
            
            exercise = e
            exerciseName.value = e.name
            exerciseReps.value = e.defaultSet?.reps ?? 0
            exerciseWeight.value = e.defaultSet?.weight ?? 0
            existsInRealm = true
            retrievedObserver.send(value: ())
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}
