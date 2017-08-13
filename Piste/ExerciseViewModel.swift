//
//  ExerciseViewModel.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

protocol SelectableExerciseProtocol {
    func selectExercise(name: String)
}

struct ExerciseViewModel {
    
    var savedSignal: Signal<Void, NSError>
    private var savedObserver: Signal<Void, NSError>.Observer
    private var exercises: Results<Exercise>?
    
    private var realm: Realm?
    
    init() {
        realm = try? Realm()
        
        (savedSignal, savedObserver) = Signal<Void, NSError>.pipe()
        
        fetchExercises()
    }
    
    var count: Int {
        return exercises?.count ?? 0
    }
    
    func exerciseName(atIndex index: Int) -> String? {
        return exercises?[index].name
    }
    
    mutating func deleteExercise(atIndex index: Int) {
        guard let exercise = exercises?[index] else { return }
        do {
            realm = try Realm()
            try realm?.write {
                if let defaultSet = exercise.defaultSet {
                    realm?.delete(defaultSet)
                }
                realm?.delete(exercise)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private mutating func fetchExercises() {
        exercises = realm?.objects(Exercise.self)
        savedObserver.send(value: ())
    }
}
