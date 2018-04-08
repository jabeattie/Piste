//
//  LoginViewController.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    init() {
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            let dashboardVC = DashboardViewController(userId: user.id)
            navigationController?.pushViewController(dashboardVC, animated: true)
            
            
        } catch let jsonError as NSError {
            print(jsonError)
        }
    }

}
