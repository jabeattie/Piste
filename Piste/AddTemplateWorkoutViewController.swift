//
//  AddTemplateWorkoutViewController.swift
//  Piste
//
//  Created by James Beattie on 13/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import JLSwiftRouter
import ReactiveSwift

class AddTemplateWorkoutViewController: UIViewController {
    
    @objc var templateWorkoutId: String? = nil
    var viewModel: AddTemplateWorkoutViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var (lifetime, token) = Lifetime.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(saveWorkout))
        self.navigationItem.rightBarButtonItem = addButton

        let templateId = Int(templateWorkoutId ?? "")
        viewModel = AddTemplateWorkoutViewModel(templateId: templateId)
        
        tableView.register(ExerciseTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel?.exercisesUpdatedSignal.observeResult({ (result) in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure:
                break
            }
        })
        
        
        viewModel!.name <~ nameTextField.reactive.continuousTextValues.map({ $0 ?? ""}).take(during: lifetime)
        
        viewModel?.savedSignal.observe(on: UIScheduler()).observeResult({ (result) in
            switch result {
            case .success(let success):
                guard success else { return }
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                return
            }
        })
    }
    
    @objc func saveWorkout() {
        viewModel?.save()
    }
    
    @IBAction func addExercisePressed(_ sender: UIButton) {
        print("Add exercise")
        
        let router = Router.shared
        let vc = router.matchControllerFromStoryboard("/exercises", storyboardName: "Main") as! ExerciseViewController
        vc.delegate = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension AddTemplateWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueResuableCell(forIndexPath: indexPath) as ExerciseTableViewCell
        cell.label.text = viewModel?.exerciseName(atIndex: indexPath.row)
        return cell
    }
}

extension AddTemplateWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let delegate = delegate {
//            guard let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row) else { return }
//            delegate.selectExercise(name: exerciseName)
//            navigationController?.popViewController(animated: true)
//        } else {
//            let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row)
//            showAddExerciseScreen(exerciseName)
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            viewModel?.deleteExercise(atIndex: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//        }
    }
}
