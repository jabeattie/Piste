//
//  AddExerciseViewModelTests.swift
//  Piste
//
//  Created by James Beattie on 28/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import XCTest
import Result
import ReactiveSwift
import RealmSwift
import Quick
import Nimble
import SwiftyMocky

@testable import Piste

class AddExerciseViewModelTests: QuickSpec {
    
    override func spec() {
        describe("AddExerciseViewModel") {
            var viewModel: AddExerciseViewModel!
            
            beforeEach {
                let realm = try? RealmProviderImpl().realm()
                try? realm?.write {
                    realm?.deleteAll()
                }
                
                viewModel = AddExerciseViewModel(exerciseName: "new")
            }
            
            describe("exerciseName") {
                context("all other data present") {
                    it("should save when set") {
                        
                        viewModel.exerciseReps.value = 10
                        viewModel.exerciseWeight.value = 20.0
                        viewModel.exerciseName.value = "exerciseName"
                        
                        waitUntil(action: { (done) in
                            viewModel.savedSignal.observeResult({ (result) in
                                let realm = try? RealmProviderImpl().realm()
                                let exercise = realm?.object(ofType: Exercise.self, forPrimaryKey: "exerciseName")
                                expect(exercise).toNot(beNil())
                                expect(result.value).to(beTrue())
                                done()
                            })
                            viewModel.save()
                        })
                    }
                }
            }
            
            describe("fetchExercise()") {
                it("should send value on signal when loaded") {
                    createAndAddExercise()
                    viewModel = AddExerciseViewModel(exerciseName: "test1")
                    
                    waitUntil(action: { (done) in
                        viewModel.retrievedSignal.observeResult({ (result) in
                            switch result {
                            case .success:
                                expect(viewModel.exerciseName.value).to(equal("test1"))
                                done()
                            case.failure(let error):
                                fail(error.localizedDescription)
                            }
                        })
                        viewModel.fetchExercise()
                    })
                }
                
                it("should send error when realm fails loading") {
                    let mock = RealmProviderMock()
                    viewModel = AddExerciseViewModel(exerciseName: "test1", realmProvider: mock)
                    Given(mock, .realm(willThrow: NSError(domain: "1", code: 1, userInfo: nil)))
                    
                    waitUntil(action: { (done) in
                        viewModel.retrievedSignal.observeResult({ (result) in
                            switch result {
                            case .success:
                                fail("Realm did not throw error")
                            case.failure(let error):
                                expect(error.code).to(equal(1))
                                done()
                            }
                        })
                        viewModel.fetchExercise()
                    })
                }
            }
            
            func createAndAddExercise() {
                let exercise = Exercise()
                exercise.name = "test1"
                let set = ExerciseSet()
                set.reps = 1
                set.weight = 2.0
                exercise.defaultSet = set
                let realm = try? RealmProviderImpl().realm()
                try? realm?.write {
                    realm?.add(exercise)
                }
            }
        }
    }
    
//
//
//
//    func testEditableNameFalse() {
//        createAndAddExercise()
//
//        viewModel = AddExerciseViewModel(exerciseName: "test1")
//        viewModel?.fetchExercise()
//
//        let editable = viewModel?.editableName ?? true
//        XCTAssertFalse(editable)
//    }
//
//    func testEditableNameTrue() {
//
//        let editable = viewModel?.editableName ?? false
//        XCTAssertTrue(editable)
//    }
    
}
