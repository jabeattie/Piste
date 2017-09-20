//
//  AddWorkoutViewModel.swift
//  Piste
//
//  Created by James Beattie on 13/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

class AddTemplateWorkoutViewModel {
    
    var savedSignal: Signal<Bool, NSError>
    var exercisesUpdatedSignal: Signal<Void, NSError>
    
    private var savedObserver: Signal<Bool, NSError>.Observer
    private var exercisesUpdatedObserver: Signal<Void, NSError>.Observer
    
    var name = MutableProperty<String>("")
    var exercises = MutableProperty<List<Exercise>>(List<Exercise>())
    var templateId: Int
    let template: TemplateWorkout
    
    init(templateId id: Int?) {
        
        (exercisesUpdatedSignal, exercisesUpdatedObserver) = Signal<Void, NSError>.pipe()
        (savedSignal, savedObserver) = Signal<Bool, NSError>.pipe()
        
        let realm = try? RealmProvider.realm()
        
        if let id = id, id >= 0, let t = realm?.object(ofType: TemplateWorkout.self, forPrimaryKey: id) {
            templateId = id
            template = t
            name.value = template.name
            exercises.value = template.exercises
        } else {
            templateId = (realm?.objects(TemplateWorkout.self).max(ofProperty: "id") as Int? ?? 0) + 1
            if let id = id, id >= 0 {
                templateId = id
            }
            template = TemplateWorkout()
            template.id = templateId
        }
        
        name.signal.observeValues { (name) in
            let realm = try? RealmProvider.realm()
            try? realm?.write {
                self.template.name = name
            }
        }
    }
    
    var count: Int {
        return template.exercises.count
    }
    
    func exerciseName(atIndex index: Int) -> String? {
        return template.exercises[index].name
    }
    
    func addExercise(name: String) {
        
        guard !name.isEmpty else { return }
        do {
            let realm = try RealmProvider.realm()
            guard let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: name) else {
                return
            }
            try realm.write {
                template.exercises.append(exercise)
            }
            exercisesUpdatedObserver.send(value: ())
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func save() {
        guard !template.name.isEmpty else { return }
        do {
            let realm = try RealmProvider.realm()
            
            try realm.write {
                realm.add(template)
            }
            savedObserver.send(value: true)
            
        } catch let error {
            savedObserver.send(value: false)
        }
    }
}

extension AddTemplateWorkoutViewModel: SelectableExerciseProtocol {
    func selectExercise(name: String) {
        addExercise(name: name)
    }
}
