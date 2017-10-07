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
        setupGradientView()
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = exerciseName == nil || exerciseName == "new" ? "Add new exercise" : "Edit \(exerciseName!)"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Exercise", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white.withAlphaComponent(0.3)])
        weightTextField.attributedPlaceholder = NSAttributedString(string: "Weight", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white.withAlphaComponent(0.3)])
        repsTextField.attributedPlaceholder = NSAttributedString(string: "Reps", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white.withAlphaComponent(0.3)])
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
    
    private func setupGradientView() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        // 3
        let color1 = UIColor(red: 255 / 255.0, green: 66 / 255.0, blue: 36 / 255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 255 / 255.0, green: 0 / 255.0, blue: 76 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0, 1.0]
        
        // 5
        view.layer.insertSublayer(gradientLayer, at: 0)
//        self.view.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        viewModel?.save()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
