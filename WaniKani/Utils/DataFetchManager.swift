//
//  DataFetchManager.swift
//
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit
import WaniKit
import RealmSwift
import PermissionScope


let realmQueue = dispatch_queue_create("REALM", DISPATCH_QUEUE_SERIAL)
var realm = {
  return try! Realm()
}

var user: User? {
  return realm().objects(User).first
}

class DataFetchManager: NSObject {
  
  static let sharedInstance = DataFetchManager()
  
  func makeInitialPreperations() {
    performMigrationIfNeeded()
    initialUserCreation()
  }
  
  func performMigrationIfNeeded() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      schemaVersion: 7,
      migrationBlock: { migration, oldSchemaVersion in
        
    })
    _ = try! Realm()
  }
  
  func fetchAllData() {
    fetchStudyQueue()
    fetchLevelProgression()
  }
  
  func initialUserCreation() {
    
    if user == nil {
      var token: dispatch_once_t = 0
      let usr = User()
      dispatch_once(&token) {
        let studyQ = StudyQueue()
        let levelProgression = LevelProgression()
        dispatch_sync(realmQueue) { () -> Void in
          let r = try! Realm()
          try! r.write({ () -> Void in
            r.add(usr)
            usr.studyQueue = studyQ
            usr.levelProgression = levelProgression
          })
        }
      }
    }
  }
  
  func fetchStudyQueue(completionHandler: ((result: UIBackgroundFetchResult)->())? = nil) {
    
    // Fetch data
    appDelegate.waniApiManager.fetchStudyQueue { (userInfo, studyQInfo) -> Void in
      
      // Make sure recieved data is OK
      guard let userInfo = userInfo, studyQInfo = studyQInfo else {
        completionHandler?(result: UIBackgroundFetchResult.Failed)
        return
      }
      
      // Update user and study queue on realmQueue
      dispatch_async(realmQueue) { () -> Void in
        
        // Make sure that user exist
        guard let user = realm().objects(User).first else { return }
        
        // Update study queue, and user info
        try! realm().write({ () -> Void in
          user.studyQueue?.updateWith(studyQInfo)
          user.updateUserWithUserInfo(userInfo)
        })
        realm().refresh()
        
        // Do some stuff with data
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          realm().refresh()
          let user = realm().objects(User).first
          guard let studyQ =  user?.studyQueue else { return }
          let result: UIBackgroundFetchResult = self.schedulePushNotificationIfNeededFor(studyQ) ? .NewData : .NoData
          appDelegate.notificationCenterManager.postNotification(.NewStudyQueueReceivedNotification, object: studyQ)
          completionHandler?(result: result)
        })
      }
      
    }
  }
  
  func schedulePushNotificationIfNeededFor(studyQueue: StudyQueue) -> Bool {
    var newNotification = false
    
    if PermissionScope().statusNotifications() != .Disabled {
      newNotification = NotificationManager.sharedInstance.scheduleNextReviewNotification(studyQueue.nextReviewDate)
      let additionalNotifications = SettingsSuit.sharedInstance.ignoreLessonsInIconCounter.setting.enabled ? 0 : studyQueue.lessonsAvaliable
      let newAppIconCounter = studyQueue.reviewsAvaliable + additionalNotifications
      let oldAppIconCounter = UIApplication.sharedApplication().applicationIconBadgeNumber
      newNotification = newNotification || (oldAppIconCounter != newAppIconCounter)
      UIApplication.sharedApplication().applicationIconBadgeNumber = newAppIconCounter
    }
    return newNotification
  }
  
  func fetchLevelProgression() {

    // Fetch data
    appDelegate.waniApiManager.fetchLevelProgression { (userInfo, levelProgressionInfo) -> Void in
      
      // Make sure recieved data is OK
      guard let userInfo = userInfo, levelProgressionInfo = levelProgressionInfo else {
        return
      }
      
      dispatch_async(realmQueue) { () -> Void in
        
        // Make sure that user exist
        guard let user = realm().objects(User).first else { return }
        
        // Update study queue, and user info
        try! realm().write({ () -> Void in
          user.levelProgression?.updateWith(levelProgressionInfo)
          user.updateUserWithUserInfo(userInfo)
        })
        realm().refresh()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          realm().refresh()
          let user = realm().objects(User).first
          guard let levelProgression =  user?.levelProgression else { return}
          appDelegate.notificationCenterManager.postNotification(.NewLevelProgressionReceivedNotification, object: levelProgression)
        })
      }
    }
  }
  
  
}
