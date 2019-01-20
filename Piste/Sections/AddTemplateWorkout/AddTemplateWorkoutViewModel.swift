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
    
    private let savedObserver: Signal<Bool, NSError>.Observer
    private let exercisesUpdatedObserver: Signal<Void, NSError>.Observer
    private let realmProvider: RealmProvider
    
    var buttonTitle: String
    var name = MutableProperty<String>("")
    var exercises = MutableProperty<List<Exercise>>(List<Exercise>())
    var templateId: Int
    let template: TemplateWorkout
    
    init(templateId id: Int?, realmProvider: RealmProvider = RealmProviderImpl()) {
        buttonTitle = id == nil ? "Create" : "Save"
        (exercisesUpdatedSignal, exercisesUpdatedObserver) = Signal<Void, NSError>.pipe()
        (savedSignal, savedObserver) = Signal<Bool, NSError>.pipe()
        self.realmProvider = realmProvider
        let realm = try? realmProvider.realm()
        
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
        
        name.signal.observeValues { [weak self] (name) in
            guard let wSelf = self else { return }
            let realm = try? wSelf.realmProvider.realm()
            try? realm?.write {
                wSelf.template.name = name
            }
        }
    }
    
    var count: Int {
        return template.exercises.count
    }
    
    func cellViewModel(at index: Int) -> ExerciseCellViewModel? {
        guard index < template.exercises.count else { return nil }
        return ExerciseCellViewModel(exercise: template.exercises[index], type: .light)
    }
    
    func addExercise(name: String) {
        
        guard !name.isEmpty else { return }
        do {
            let realm = try realmProvider.realm()
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
            let realm = try realmProvider.realm()
            
            try realm.write {
                realm.add(template)
            }
            savedObserver.send(value: true)
            
        } catch let error {
            print(error.localizedDescription)
            savedObserver.send(value: false)
        }
    }
}

extension AddTemplateWorkoutViewModel: SelectableExerciseProtocol {
    func selectExercise(name: String) {
        addExercise(name: name)
    }
}
