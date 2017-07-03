//
//  User.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var age = 0
    let templates = List<TemplateWorkout>()
    let workouts = List<Workout>()
}
