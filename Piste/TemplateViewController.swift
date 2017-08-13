//
//  TemplateViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import JLSwiftRouter
import ReactiveSwift

class TemplateWorkoutsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TemplateWorkoutsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAddTemplateWorkoutScreen))
        self.navigationItem.rightBarButtonItem = addButton
        
        viewModel = TemplateWorkoutsViewModel()
        
        viewModel?.resultsUpdatedSignal.observeResult({ [weak self] (result) in
            switch result {
            case .success:
                self?.tableView.reloadData()
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        tableView.register(WorkoutTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func showNewAddTemplateWorkoutScreen() {
        showAddTemplateWorkoutScreen(nil)
    }
    
    func showAddTemplateWorkoutScreen(_ templateWorkoutId: Int?) {
        let id = templateWorkoutId ?? -1
        let router = Router.shared
        let vc = router.matchControllerFromStoryboard("/addTemplateWorkout/\(id)", storyboardName: "Main") as! AddTemplateWorkoutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TemplateWorkoutsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueResuableCell(forIndexPath: indexPath) as WorkoutTableViewCell
        cell.label.text = viewModel?.templateWorkoutName(atIndex: indexPath.row)
        return cell
    }
}

extension TemplateWorkoutsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let templateWorkoutId = viewModel?.templateWorkoutId(atIndex: indexPath.row)
        showAddTemplateWorkoutScreen(templateWorkoutId)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteTemplateWorkout(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
