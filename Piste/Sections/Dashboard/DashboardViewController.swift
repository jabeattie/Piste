//
//  DashboardViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var workoutsButton: UIButton!
    @IBOutlet weak var exercisesButton: UIButton!
    private let viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DashboardViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        addGradientView()
        welcomeLabel.text = viewModel.title
        startButton.layer.cornerRadius = 30
        workoutsButton.layer.cornerRadius = 25
        exercisesButton.layer.cornerRadius = 25
    }
    
    @IBAction func startTapped(_ sender: UIButton) {
    }
    
    @IBAction func exercisesTapped(_ sender: UIButton) {
        let viewModel = ExerciseViewModel()
        let vc = ExerciseViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func workoutsTapped(_ sender: UIButton) {
        let viewModel = TemplateWorkoutsViewModel()
        let vc = TemplateWorkoutsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
