//
//  AddExerciseViewController.swift
//  Piste
//
//  Created by James Beattie on 10/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveSwift
import ReactiveCocoa

class AddExerciseViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @objc var exerciseName: String?
    
    var viewModel: AddExerciseViewModel?
    
    private var (lifetime, token) = Lifetime.make()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel = AddExerciseViewModel(exerciseName: exerciseName)
        viewModel?.savedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success(let success):
                if success {
                    self?.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(let error):
                break
            }
        })
        
        viewModel!.exerciseName <~ nameTextField.reactive.continuousTextValues.map({ $0 ?? ""}).take(during: lifetime)
        viewModel!.exerciseReps <~ repsTextField.reactive.continuousTextValues.map({ Int($0 ?? "0") ?? 0 }).take(during: lifetime)
        viewModel!.exerciseWeight <~ weightTextField.reactive.continuousTextValues.map({ Double($0 ?? "0") ?? 0.0 }).take(during: lifetime)
        
        viewModel?.retrievedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.nameTextField.text = self?.viewModel?.exerciseName.value
                self?.repsTextField.text = "\(self?.viewModel?.exerciseReps.value ?? 0)"
                self?.weightTextField.text = "\(self?.viewModel?.exerciseWeight.value ?? 0)"
            case .failure:
                break
            }
        })
        
        viewModel?.fetchExercise()
        nameTextField.isEnabled = viewModel?.editableName ?? true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        viewModel?.save()
    }

}
