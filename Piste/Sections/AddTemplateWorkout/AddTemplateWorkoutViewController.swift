//
//  AddTemplateWorkoutViewController.swift
//  Piste
//
//  Created by James Beattie on 13/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import ReactiveSwift

class AddTemplateWorkoutViewController: UIViewController {
    
    @objc var templateWorkoutId: String? = nil
    var viewModel: AddTemplateWorkoutViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    
    private var (lifetime, token) = Lifetime.make()
    
    init(viewModel: AddTemplateWorkoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: AddTemplateWorkoutViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        setupCollectionView()
        setupViewModel()
        bottomButton.setTitle(viewModel.buttonTitle, for: .normal)
    }
    
    @IBAction func saveWorkout(_ sender: UIButton) {
        viewModel.save()
    }
    
    @IBAction func addExercisePressed(_ sender: UIButton) {
        print("Add exercise")
        // TODO: Replace router
//        let router = Router.shared
//        let vc = router.matchControllerFromStoryboard("/exercises", storyboardName: "Main") as! ExerciseViewController
//        vc.delegate = viewModel
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ExerciseViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.exercisesUpdatedSignal.observeResult({ (result) in
            switch result {
            case .success:
                self.collectionView.reloadData()
            case .failure:
                break
            }
        })
        
        nameTextField.text = viewModel.name.value
        viewModel.name <~ nameTextField.reactive.continuousTextValues.map({ $0 ?? ""}).take(during: lifetime)
        
        viewModel.savedSignal.observe(on: UIScheduler()).observeResult({ (result) in
            switch result {
            case .success(let success):
                guard success else { return }
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                return
            }
        })
    }

}

extension AddTemplateWorkoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExerciseViewCell = collectionView.dequeueResuableCell(for: indexPath)
        if let cvm = viewModel.cellViewModel(at: indexPath.item) {
            cell.configure(cvm)
        }
        return cell
    }
}

extension AddTemplateWorkoutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if let delegate = delegate {
        //            guard let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row) else { return }
        //            delegate.selectExercise(name: exerciseName)
        //            navigationController?.popViewController(animated: true)
        //        } else {
        //            let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row)
        //            showAddExerciseScreen(exerciseName)
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 66)
    }
}
