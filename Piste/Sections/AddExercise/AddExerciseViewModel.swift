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
    
    var title: String
    var savedSignal: Signal<Bool, NSError>
    var savedObserver: Signal<Bool, NSError>.Observer
    var retrievedSignal: Signal<Void, NSError>
    var retrievedObserver: Signal<Void, NSError>.Observer
    var exerciseName = MutableProperty<String>("")
    var exerciseReps = MutableProperty<Int>(0)
    var exerciseWeight = MutableProperty<Double>(0)
    
    private var exercise = Exercise()
    private var existsInRealm = false
    private let realmProvider: RealmProvider
    
    var editableName: Bool {
        return !existsInRealm
    }
    
    init(exerciseName: String?, realmProvider: RealmProvider = RealmProviderImpl()) {
        (savedSignal, savedObserver) = Signal<Bool, NSError>.pipe()
        (retrievedSignal, retrievedObserver) = Signal<Void, NSError>.pipe()
        self.realmProvider = realmProvider
        if let exName = exerciseName, exName != "new" {
            self.title = "Edit \(exName)"
            self.exerciseName.value = exName
        } else {
            self.title = "Add new exercise"
            self.exerciseName.signal.observeValues({ [weak self] name in
                guard let wSelf = self else { return }
                do {
                    let realm = try wSelf.realmProvider.realm()
                    
                    try realm.write {
                        wSelf.exercise.name = name
                    }
                } catch let error {
                    wSelf.savedObserver.send(value: false)
                }
            })
        }
        exerciseReps.signal.observeValues({ [weak self] reps in
            guard let wSelf = self else { return }
            do {
                let realm = try wSelf.realmProvider.realm()
                
                try realm.write {
                    if let set = wSelf.exercise.defaultSet {
                        set.reps = reps
                        wSelf.exercise.defaultSet = set
                    } else {
                        let set = ExerciseSet()
                        set.reps = reps
                        wSelf.exercise.defaultSet = set
                    }
                }
            } catch let error {
                wSelf.savedObserver.send(value: false)
            }
        })
        exerciseWeight.signal.observeValues({ [weak self] weight in
            guard let wSelf = self else { return }
            do {
                let realm = try wSelf.realmProvider.realm()
                
                try realm.write {
                    if let set = wSelf.exercise.defaultSet {
                        set.weight = weight
                        wSelf.exercise.defaultSet = set
                    } else {
                        let set = ExerciseSet()
                        set.weight = weight
                        wSelf.exercise.defaultSet = set
                    }
                }
            } catch let error {
                wSelf.savedObserver.send(value: false)
            }
            
           
        })
    }
    
    func save() {
        do {
            let realm = try realmProvider.realm()
            
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
            let realm = try realmProvider.realm()
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
            retrievedObserver.send(error: error as NSError)
            print(error.localizedDescription)
        }
        
    }
    
}
