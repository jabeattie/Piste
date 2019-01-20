//
//  DashboardViewModel.swift
//  Piste
//
//  Created by James Beattie on 20/01/2019.
//  Copyright © 2019 James Beattie. All rights reserved.
//

import Foundation

class DashboardViewModel {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var title: String {
        return "Welcome \(user.name)"
    }
}
