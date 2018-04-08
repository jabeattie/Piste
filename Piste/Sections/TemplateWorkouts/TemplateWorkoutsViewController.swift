//
//  TemplateViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import ReactiveSwift

class TemplateWorkoutsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: TemplateWorkoutsViewModel
    
    init(viewModel: TemplateWorkoutsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TemplateWorkoutsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAddTemplateWorkoutScreen))
        self.navigationItem.rightBarButtonItem = addButton
        title = "Workouts"
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        viewModel = TemplateWorkoutsViewModel()
        
        viewModel.resultsUpdatedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.collectionView.reloadData()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc func showNewAddTemplateWorkoutScreen() {
        showAddTemplateWorkoutScreen(nil)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WorkoutViewCell.self)
    }
    
    func showAddTemplateWorkoutScreen(_ templateWorkoutId: Int?) {
        let viewModel = AddTemplateWorkoutViewModel(templateId: templateWorkoutId)
        let vc = AddTemplateWorkoutViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TemplateWorkoutsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WorkoutViewCell = collectionView.dequeueResuableCell(for: indexPath)
        cell.label.text = viewModel.templateWorkoutName(atIndex: indexPath.item)
        return cell
    }
}

extension TemplateWorkoutsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let templateWorkoutId = viewModel.templateWorkoutId(atIndex: indexPath.item)
        showAddTemplateWorkoutScreen(templateWorkoutId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }
    
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            viewModel.deleteTemplateWorkout(atIndex: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//        }
//    }
}
