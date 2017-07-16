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
    
    var exercises: [Exercise] = []
    
//    var viewModel: 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise))
        self.navigationItem.rightBarButtonItem = addButton
        
        tableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        exercises = realm.objects(Exercise.self).map { $0 }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addExercise() {
        let router = Router.shared
        let vc = router.matchControllerFromStoryboard("/addExercise/new", storyboardName: "Main") as! AddExerciseViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExerciseTableViewCell
        cell.label.text = exercises[indexPath.row].name
        return cell
    }
}
