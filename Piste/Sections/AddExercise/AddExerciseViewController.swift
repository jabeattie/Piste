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
    
    var viewModel: AddExerciseViewModel
    
    private var (lifetime, token) = Lifetime.make()
    
    init(viewModel: AddExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: AddExerciseViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = viewModel.title
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Exercise", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        weightTextField.attributedPlaceholder = NSAttributedString(string: "Weight", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        repsTextField.attributedPlaceholder = NSAttributedString(string: "Reps", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        // Do any additional setup after loading the view.
        
        viewModel.savedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success(let success):
                if success {
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                break
            }
        })
        
        viewModel.exerciseName <~ nameTextField.reactive.continuousTextValues.map({ $0 ?? ""}).take(during: lifetime)
        viewModel.exerciseReps <~ repsTextField.reactive.continuousTextValues.map({ Int($0 ?? "0") ?? 0 }).take(during: lifetime)
        viewModel.exerciseWeight <~ weightTextField.reactive.continuousTextValues.map({ Double($0 ?? "0") ?? 0.0 }).take(during: lifetime)
        
        viewModel.retrievedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.nameTextField.text = self?.viewModel.exerciseName.value
                self?.repsTextField.text = "\(self?.viewModel.exerciseReps.value ?? 0)"
                self?.weightTextField.text = "\(self?.viewModel.exerciseWeight.value ?? 0)"
            case .failure:
                break
            }
        })
        
        viewModel.fetchExercise()
        nameTextField.isEnabled = viewModel.editableName
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        viewModel.save()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
