//
//  ExerciseViewController.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import JLSwiftRouter
import RealmSwift

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ExerciseViewModel?
    var delegate: SelectableExerciseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAddExerciseScreen))
        self.navigationItem.rightBarButtonItem = addButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        setupViewModel()
        setupTableView()
        setupSearchController()
        title = viewModel?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.pisteRed
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        viewModel?.savedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.tableView.reloadData()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(ExerciseTableViewCell.self)
    }
    
    @objc func showNewAddExerciseScreen() {
        showAddExerciseScreen(nil)
    }
    
    func showAddExerciseScreen(_ exerciseName: String?) {
        let name = exerciseName ?? "new"
        let router = Router.shared
        let vc = router.matchControllerFromStoryboard("/addExercise/\(name)", storyboardName: "Main") as! AddExerciseViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExerciseTableViewCell = tableView.dequeueResuableCell(forIndexPath: indexPath)
        cell.label.text = viewModel?.exerciseName(atIndex: indexPath.row)
        cell.weightLabel.text = viewModel?.exerciseWeight(atIndex: indexPath.row)
        cell.repsLabel.text = viewModel?.exerciseReps(atIndex: indexPath.row)
        return cell
    }
}

extension ExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            guard let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row) else { return }
            delegate.selectExercise(name: exerciseName)
            navigationController?.popViewController(animated: true)
        } else {
            let exerciseName = viewModel?.exerciseName(atIndex: indexPath.row)
            showAddExerciseScreen(exerciseName)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteExercise(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension ExerciseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        viewModel?.update(searchPattern: searchTerm)
        tableView.reloadData()
    }
}
