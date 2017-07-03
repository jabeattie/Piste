//
//  RealmService.swift
//  Piste
//
//  Created by James Beattie on 03/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import RealmSwift
import JLSwiftRouter

class RealmService: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    convenience init(window: UIWindow?) {
        self.init()
        self.window = window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        let router = Router.shared
        let navC: UINavigationController
//        navC.navigationBar = UINavigationBar()
//        navC.navigationBar.barStyle = .default
//        navC.navigationBar.isTranslucent = false
        do {
            
            let config = Realm.Configuration(
                schemaVersion: 2,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 2 {
                        
                    }
            })
            
            Realm.Configuration.defaultConfiguration = config
            
            let realm = try Realm()
            
            let users = realm.objects(User.self)
            
            if users.count > 0 {
                let dashboardVC = router.matchControllerFromStoryboard("/dashboard/\(users.first!.id)", storyboardName: "Main") as! DashboardViewController
                navC = UINavigationController(rootViewController: dashboardVC)
            } else {
                let loginVC = router.matchControllerFromStoryboard("/login", storyboardName: "Main") as! LoginViewController
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
