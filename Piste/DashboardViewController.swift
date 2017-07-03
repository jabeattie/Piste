//
//  DashboardViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import JLSwiftRouter

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userIDLabel.text = userId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func exercisesTapped(_ sender: UIButton) {
        let router = Router.shared
        let vc = router.matchControllerFromStoryboard("/exercises", storyboardName: "Main") as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
