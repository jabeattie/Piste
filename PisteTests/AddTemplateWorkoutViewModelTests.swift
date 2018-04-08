//
//  AddTemplateWorkoutViewModelTests.swift
//  Piste
//
//  Created by James Beattie on 28/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import XCTest
import Result
import ReactiveSwift
import RealmSwift

@testable import Piste

class AddTemplateWorkoutViewModelTests: XCTestCase {
    
    var viewModel: AddTemplateWorkoutViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let realm = try! RealmProvider.realm()
        try! realm.write {
            realm.deleteAll()
        }
        viewModel = AddTemplateWorkoutViewModel(templateId: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWorkoutName() {
        
        let exp = expectation(description: "Workout created")
        
        viewModel?.name.value = "workoutName"
        
        viewModel?.savedSignal.observeResult({ (result) in
            if result.value ?? false {
                let realm = try! RealmProvider.realm()
                let exercise = realm.objects(TemplateWorkout.self)
                if !exercise.isEmpty {
                    exp.fulfill()
                }
            }
        })
        
        viewModel?.save()
        
        waitForExpectations(timeout: 10.0) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }

    func testFetchTemplate() {
        createAndAddTemplateWorkout()
        
        viewModel = AddTemplateWorkoutViewModel(templateId: 1)
        
        XCTAssertEqual(viewModel?.templateId, 1)
        XCTAssertEqual(viewModel?.name.value, "test1")
        XCTAssertEqual(viewModel?.count, 0)
    }
    
    func testAddExercise() {
        createAndAddTemplateWorkout()
        
        viewModel = AddTemplateWorkoutViewModel(templateId: 1)
        
        createAndAddExercise()
        viewModel?.addExercise(name: "test2")
        
        XCTAssertEqual(viewModel?.count, 1)
    }
    
    func testExerciseName() {
        createAndAddTemplateWorkout()
        
        viewModel = AddTemplateWorkoutViewModel(templateId: 1)
        
        createAndAddExercise()
        viewModel?.addExercise(name: "test2")
        let exerciseName = viewModel?.exerciseName(atIndex: 0)
        XCTAssertEqual(exerciseName, "test2")
    }
    
    func testExerciseGeneration() {
        createAndAddTemplateWorkout()
        
        viewModel = AddTemplateWorkoutViewModel(templateId: nil)
        
        createAndAddExercise()
        
        viewModel?.selectExercise(name: "test2")
        
        XCTAssertEqual(viewModel?.count, 1)
    }
    
    private func createAndAddTemplateWorkout() {
        let template = TemplateWorkout()
        template.name = "test1"
        template.id = 1
        let realm = try! RealmProvider.realm()
        try! realm.write {
            realm.add(template)
        }
    }
    
    private func createAndAddExercise() {
        let exercise = Exercise()
        exercise.name = "test2"
        let set = ExerciseSet()
        set.reps = 1
        set.weight = 2.0
        exercise.defaultSet = set
        let realm = try! RealmProvider.realm()
        try! realm.write {
            realm.add(exercise)
        }
    }
    
}
