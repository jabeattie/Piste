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

struct TemplateWorkoutsViewModel {
    
    var resultsUpdatedSignal: Signal<Void, NSError>
    private var resultsUpdatedObserver: Signal<Void, NSError>.Observer
    private var templateWorkouts: Results<TemplateWorkout>?
    
    private var realm: Realm?
    
    init() {
        realm = try? Realm()
        
        (resultsUpdatedSignal, resultsUpdatedObserver) = Signal<Void, NSError>.pipe()
        
        fetchTemplateWorkouts()
    }
    
    var count: Int {
        return templateWorkouts?.count ?? 0
    }
    
    func templateWorkoutName(atIndex index: Int) -> String? {
        return templateWorkouts?[index].name
    }
    
    func templateWorkoutId(atIndex index: Int) -> Int? {
        return templateWorkouts?[index].id
    }
    
    mutating func deleteTemplateWorkout(atIndex index: Int) {
        guard let templateWorkout = templateWorkouts?[index] else { return }
        do {
            realm = try Realm()
            try realm?.write {
                realm?.delete(templateWorkout)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private mutating func fetchTemplateWorkouts() {
        templateWorkouts = realm?.objects(TemplateWorkout.self)
        resultsUpdatedObserver.send(value: ())
    }
    
}
