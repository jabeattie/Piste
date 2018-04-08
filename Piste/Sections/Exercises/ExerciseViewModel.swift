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
import Fuse

protocol SelectableExerciseProtocol {
    func selectExercise(name: String)
}

struct ExerciseViewModel {
    
    var savedSignal: Signal<Void, NSError>
    private var savedObserver: Signal<Void, NSError>.Observer
    private var exercises: Results<Exercise>?
    private var filteredExercises: [Exercise]? {
        guard let fp = fusePattern else {
            return exercises?.map { $0 }
        }
        return exercises?.filter({ fuse.search(fp, in: $0.name) != nil })
    }
    
    private var fuse = Fuse()
    private var fusePattern: Fuse.Pattern?
    
    private var realm: Realm?
    
    init() {
        realm = try? Realm()
        (savedSignal, savedObserver) = Signal<Void, NSError>.pipe()
        
        fetchExercises()
    }
    
    var title: String {
        return "Exercises"
    }
    
    var count: Int {
        return filteredExercises?.count ?? 0
    }
    
    func exerciseName(atIndex index: Int) -> String? {
        return filteredExercises?[index].name
    }
    
    func exerciseWeight(atIndex index: Int) -> String? {
        guard let weight = filteredExercises?[index].defaultSet?.weight else { return nil }
        return String(format: "%.1f", weight)
    }
    
    func exerciseReps(atIndex index: Int) -> String? {
        guard let reps = filteredExercises?[index].defaultSet?.reps else { return nil }
        return String(reps)
    }
    
    mutating func deleteExercise(atIndex index: Int) {
        guard let exercise = filteredExercises?[index] else { return }
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
    
    mutating func update(searchPattern: String) {
        guard !searchPattern.isEmpty else {
            fusePattern = nil
            return
        }
        fusePattern = fuse.createPattern(from: searchPattern)
    }
}
