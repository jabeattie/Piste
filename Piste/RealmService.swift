//
//  RealmService.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift

class RealmService: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    convenience init(window: UIWindow?) {
        self.init()
        self.window = window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        
        let navC: UINavigationController
        do {
            
            let config = Realm.Configuration(
                schemaVersion: 4,
                migrationBlock: { _, oldSchemaVersion in
                    if oldSchemaVersion < 4 {
                        
                    }
            })
            
            Realm.Configuration.defaultConfiguration = config
            
            let realm = try RealmProviderImpl().realm()
                
            let users = realm.objects(User.self)
            
            if let first = users.first {
                let viewModel = DashboardViewModel(user: first)
                let dashboardVC = DashboardViewController(viewModel: viewModel)
                navC = UINavigationController(rootViewController: dashboardVC)
            } else {
                let loginVC = LoginViewController()
                navC = UINavigationController(rootViewController: loginVC)
            }
            
        } catch let error {
            print(error)
            navC = UINavigationController(rootViewController: UIViewController())
        }
        navC.navigationBar.isHidden = false
        navC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navC.navigationBar.shadowImage = UIImage()
        navC.navigationBar.isTranslucent = false
        window?.rootViewController = navC
        window?.makeKeyAndVisible()
        
        return true
    }
}
