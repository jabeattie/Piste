//
//  Exercise.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    dynamic var name = ""
    dynamic var defaultSet: ExerciseSet? = nil
}
