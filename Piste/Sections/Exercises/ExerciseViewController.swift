//
//  ExerciseViewController.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ExerciseViewModel
    var delegate: SelectableExerciseProtocol?
    
    init(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ExerciseViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAddExerciseScreen))
        self.navigationItem.rightBarButtonItem = addButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        setupViewModel()
        setupCollectionView()
        setupSearchController()
        title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.pisteRed
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func setupViewModel() {
        viewModel = ExerciseViewModel()
        viewModel.savedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.collectionView.reloadData()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExerciseViewCell.self)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 2.0
        }
    }
    
    @objc func showNewAddExerciseScreen() {
        showAddExerciseScreen(nil)
    }
    
    func showAddExerciseScreen(_ exerciseName: String?) {
        let name = exerciseName ?? "new"
        let viewModel = AddExerciseViewModel(exerciseName: name)
        let vc = AddExerciseViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ExerciseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExerciseViewCell = collectionView.dequeueResuableCell(for: indexPath)
        cell.label.text = viewModel.exerciseName(atIndex: indexPath.item)
        cell.weightLabel.text = viewModel.exerciseWeight(atIndex: indexPath.item)
        cell.repsLabel.text = viewModel.exerciseReps(atIndex: indexPath.item)
        return cell
    }
}

extension ExerciseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            guard let exerciseName = viewModel.exerciseName(atIndex: indexPath.item) else { return }
            delegate.selectExercise(name: exerciseName)
            navigationController?.popViewController(animated: true)
        } else {
            let exerciseName = viewModel.exerciseName(atIndex: indexPath.row)
            showAddExerciseScreen(exerciseName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 76)
    }
    
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            viewModel?.deleteExercise(atIndex: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//        }
//    }
}

extension ExerciseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        viewModel.update(searchPattern: searchTerm)
        collectionView.reloadData()
    }
}
