//
//  TemplateViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController {
    var templateId: Int?
    
    var viewModel: TemplateViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TemplateViewModel(templateId: templateId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addExercisePressed(_ sender: UIButton) {
        viewModel?.addExercise(name: "Hi")
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
