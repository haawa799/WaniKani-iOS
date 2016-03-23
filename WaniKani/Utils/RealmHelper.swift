//
//  RealmHelper.swift
//  WaniKani
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation
import RealmSwift

private let appGroupIdentifier = "group.com.haawa.WaniKani"
private let realmFileName = "/default.realm"

public let realmQueue = dispatch_queue_create("REALM", DISPATCH_QUEUE_SERIAL)
public var realm: Realm {
  return try! Realm()
}
public var user: User? {
  return realm.objects(User).first
}


// MARK: - DataProvider
extension DataProvider {
  static func makeInitialPreperations() {
    performMigrationIfNeeded()
    initialUserCreation()
  }
  
  private static func performMigrationIfNeeded() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      schemaVersion: 12,
      migrationBlock: { migration, oldSchemaVersion in
        
    })
  }
  
  private static func initialUserCreation() {
    if user == nil {
      var token: dispatch_once_t = 0
      let usr = User()
      dispatch_once(&token) {
        let studyQ = StudyQueue()
        let levelProgression = LevelProgression()
        dispatch_sync(realmQueue) { () -> Void in
          try! realm.write({ () -> Void in
            realm.add(usr)
            usr.studyQueue = studyQ
            usr.levelProgression = levelProgression
          })
        }
      }
    }
  }
  
}