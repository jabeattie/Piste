//
//  RouterService.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit
import JLSwiftRouter
import RealmSwift

class RouterService: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        let router = Router.shared
        router.map("/login", controllerClass: LoginViewController.self)
        router.map("/dashboard/:userId", controllerClass: DashboardViewController.self)
        router.map("/exercises", controllerClass: ExerciseViewController.self)
        return true
    }
    
}
