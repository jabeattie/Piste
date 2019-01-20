//
//  AddTemplateWorkoutViewModelTests.swift
//  Piste
//
//  Created by James Beattie on 28/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Quick
import Nimble
import SwiftyMocky
import Result
import ReactiveSwift
import RealmSwift

@testable import Piste

class AddTemplateWorkoutViewModelTests: QuickSpec {
    
    override func spec() {
        describe("AddTemplateWorkoutViewModel") {
            var subject: AddTemplateWorkoutViewModel!
            
            afterEach {
                let realm = try! RealmProviderImpl().realm()
                try! realm.write {
                    realm.deleteAll()
                }
            }
            
            context("new workout") {
                beforeEach {
                    subject = AddTemplateWorkoutViewModel(templateId: nil)
                }
                
                it("save should work") {
                    subject.name.value = "workoutName"
                    waitUntil(action: { (done) in
                        subject.savedSignal.observeResult({ (result) in
                            guard result.value != nil else {
                                fail()
                                return
                            }
                            let realm = try! RealmProviderImpl().realm()
                            let exercise = realm.objects(TemplateWorkout.self)
                            if !exercise.isEmpty {
                                done()
                            }
                        })
                        subject.save()
                    })
                }
            }
            
            context("existing workout") {
                beforeEach {
                    createAndAddTemplateWorkout()
                    subject = AddTemplateWorkoutViewModel(templateId: 1)
                }
                
                it("should load the existing template") {
                    expect(subject.templateId).to(equal(1))
                    expect(subject.name.value).to(equal("test1"))
                    expect(subject.count).to(equal(0))
                }
                
                it("should create the next template if doesn't exist") {
                    subject = AddTemplateWorkoutViewModel(templateId: 51)
                    expect(subject.templateId).to(equal(51))
                    expect(subject.template.realm).to(beNil())
                }
                
                it("add exercise should increase the count") {
                    expect(subject.count).to(equal(0))
                    createAndAddExerciseToRealm()
                    subject.addExercise(name: "test2")
                    expect(subject.count).to(equal(1))
                }
                
                it("cellViewModel should return cell for valid index") {
                    createAndAddExerciseToRealm()
                    subject.addExercise(name: "test2")
                    let cell = subject.cellViewModel(at: 0)
                    expect(cell?.name).to(equal("test2"))
                }
                
                it("cellViewModel should return nil for invalid index") {
                    let cell = subject.cellViewModel(at: 0)
                    expect(cell).to(beNil())
                }
                
                it("select exercise should add it to list") {
                    createAndAddExerciseToRealm()
                    
                    subject.selectExercise(name: "test2")
                    expect(subject.count).to(equal(1))
                }
                
                func createAndAddTemplateWorkout() {
                    let template = TemplateWorkout()
                    template.name = "test1"
                    template.id = 1
                    let realm = try! RealmProviderImpl().realm()
                    try! realm.write {
                        realm.add(template)
                    }
                }
                
                func createAndAddExerciseToRealm() {
                    let exercise = Exercise()
                    exercise.name = "test2"
                    let set = ExerciseSet()
                    set.reps = 1
                    set.weight = 2.0
                    exercise.defaultSet = set
                    let realm = try! RealmProviderImpl().realm()
                    try! realm.write {
                        realm.add(exercise)
                    }
                }
            }
        }
    }
}
