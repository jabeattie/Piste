//
//  RealmProvider.swift
//  Piste
//
//  Created by James Beattie on 28/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import RealmSwift

//sourcery: AutoMockable
protocol RealmProvider {
    func realm() throws -> Realm
}

class RealmProviderImpl: RealmProvider {
    func realm() throws -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try
                Realm(configuration: Realm.Configuration(
                    fileURL: nil,
                    inMemoryIdentifier: "test",
                    syncConfiguration: nil,
                    encryptionKey: nil,
                    readOnly: false,
                    schemaVersion: 0,
                    migrationBlock: nil,
                    deleteRealmIfMigrationNeeded: false,
                    shouldCompactOnLaunch: nil,
                    objectTypes: nil))
        } else {
            return try Realm()
        }
    }
}
