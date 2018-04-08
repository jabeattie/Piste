//
//  DashboardViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    private var userId: Int
    
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: String(describing: DashboardViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userIDLabel.text = "\(userId)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
