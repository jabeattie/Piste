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

@testable import Piste

class AddExerciseViewModelTests: XCTestCase {
    
    var viewModel: AddExerciseViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let realm = try! RealmProvider.realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        viewModel = AddExerciseViewModel(exerciseName: "new")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExerciseName() {
        
        let exp = expectation(description: "Exercise created")
        
        viewModel?.exerciseName.value = "exerciseName"
        viewModel?.exerciseReps.value = 10
        viewModel?.exerciseWeight.value = 20.0
        
        viewModel?.savedSignal.observeResult({ (result) in
            if result.value ?? false {
                let realm = try! RealmProvider.realm()
                let exercise = realm.objects(Exercise.self)
                if exercise.count > 0 {
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
    
    func testFetchExercise() {
        createAndAddExercise()
        
        viewModel = AddExerciseViewModel(exerciseName: "test1")
        
        let exp = expectation(description: "Exercise retrieved")
        
        viewModel?.retrievedSignal.observeResult({ (result) in
            switch result {
            case .success:
                exp.fulfill()
                let name = self.viewModel?.exerciseName.value
                XCTAssertEqual(name, "test1")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        viewModel?.fetchExercise()
        
        waitForExpectations(timeout: 10.0) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testEditableNameFalse() {
        createAndAddExercise()
        
        viewModel = AddExerciseViewModel(exerciseName: "test1")
        viewModel?.fetchExercise()
        
        let editable = viewModel?.editableName ?? true
        XCTAssertFalse(editable)
    }
    
    func testEditableNameTrue() {
        
        let editable = viewModel?.editableName ?? false
        XCTAssertTrue(editable)
    }
    
    private func createAndAddExercise() {
        let exercise = Exercise()
        exercise.name = "test1"
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
