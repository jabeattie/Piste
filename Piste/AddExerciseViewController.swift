//
//  AddExerciseViewController.swift
//  Piste
//
//  Created by James Beattie on 10/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift

class AddExerciseViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    var exerciseName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let exercise = Exercise()
        let realm = try! Realm()
        exercise.name = nameTextField.text!
        let defaultSet = ExerciseSet()
        defaultSet.reps = Int(repsTextField.text!)!
        defaultSet.weight = Double(weightTextField.text!)!
        exercise.defaultSet = defaultSet
        try! realm.write {
            realm.add(exercise)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
