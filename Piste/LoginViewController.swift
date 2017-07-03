//
//  LoginViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift
import JLSwiftRouter

class LoginViewController: UIViewController {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let ageString = ageTextField.text,
            let name = nameTextField.text,
            let age = Int(ageString),
            age > 0,
            !name.isEmpty
            else {
                return
        }
        
        do {
                
            let user = User()
            user.age = age
            user.name = name
            user.id = 1
            
            let realm = try Realm()
            try realm.write {
                realm.add(user)
            }
            
            let router = Router.shared
            let dashboardVC = router.matchControllerFromStoryboard("/dashboard/\(user.id)", storyboardName: "Main") as! DashboardViewController
            navigationController?.pushViewController(dashboardVC, animated: true)
            
            
        } catch let jsonError as NSError {
            print(jsonError)
        }
    }

}
