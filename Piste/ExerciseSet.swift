//
//  Set.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class ExerciseSet: Object {
    @objc dynamic var reps = 0
    @objc dynamic var weight = 0.0
}
