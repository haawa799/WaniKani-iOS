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

class DataFetchManager: NSObject {
  
  static let sharedInstance = DataFetchManager()
  
  func performMigrationIfNeeded() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      schemaVersion: 4,
      migrationBlock: { migration, oldSchemaVersion in
        
    })
    _ = try! Realm()
  }
  
  func fetchAllData() {
    fetchStudyQueue(nil)
    fetchLevelProgression()
  }
  
  private func createUser(userInfo: UserInfo) -> User {
    let usr = User(userInfo: userInfo)
    dispatch_async(realmQueue) { () -> Void in
      try! realm.write({ () -> Void in
        realm.add(usr)
      })
    }
    return usr
  }
  
  func fetchStudyQueue(completionHandler: ((result: UIBackgroundFetchResult)->())?) {
    
    appDelegate.waniApiManager.fetchStudyQueue { (userInfo, studyQInfo) -> Void in
      
      guard let userInfo = userInfo, studyQInfo = studyQInfo else {
        completionHandler?(result: UIBackgroundFetchResult.Failed)
        return
      }
      
      dispatch_async(realmQueue) { () -> Void in
        try! realm.write({ () -> Void in
          
          if let user = user {
            user.studyQueue?.updateWith(studyQInfo)
            user.updateUserWithUserInfo(userInfo)
          } else {
            let usr = self.createUser(userInfo)
            let studyQ = StudyQueue(studyQueueInfo: studyQInfo)
            dispatch_async(realmQueue, { () -> Void in
              try! realm.write({ () -> Void in
                usr.studyQueue = studyQ
              })
            })
          }
        })
        
        var newNotification = false
        if let q = user?.studyQueue /*where PermissionScope().statusNotifications() == .Authorized*/ {
          
          newNotification = NotificationManager.sharedInstance.scheduleNextReviewNotification(q.nextReviewDate)
          let newAppIconCounter = q.reviewsAvaliable + q.lessonsAvaliable
          let oldAppIconCounter = UIApplication.sharedApplication().applicationIconBadgeNumber
          newNotification = newNotification || (oldAppIconCounter != newAppIconCounter)
          UIApplication.sharedApplication().applicationIconBadgeNumber = newAppIconCounter
          appDelegate.notificationCenterManager.postNotification(.NewStudyQueueReceivedNotification, object: q)
        }
        if newNotification {
          completionHandler?(result: UIBackgroundFetchResult.NewData)
        } else {
          completionHandler?(result: UIBackgroundFetchResult.NoData)
        }
      }
    }
  }
  
  func fetchLevelProgression() {
    
    appDelegate.waniApiManager.fetchLevelProgression { (userInfo, levelProgressionInfo) -> Void in
      guard let userInfo = userInfo, levelProgressionInfo = levelProgressionInfo else {
        return
      }
      dispatch_async(realmQueue) { () -> Void in
        try! realm.write({ () -> Void in
          
          if let user = user {
            if user.levelProgression != nil {
              user.levelProgression?.updateWith(levelProgressionInfo)
            } else {
              user.levelProgression = LevelProgression(levelProgressInfo: levelProgressionInfo)
            }
            user.updateUserWithUserInfo(userInfo)
          } else {
//            let usr = self.createUser(userInfo)
//            let levelProgression = LevelProgression(levelProgressInfo: levelProgressionInfo)
//            dispatch_async(realmQueue, { () -> Void in
//              try! realm.write({ () -> Void in
//                usr.levelProgression = levelProgression
//              })
//            })
          }
        })
        
        appDelegate.notificationCenterManager.postNotification(.NewLevelProgressionReceivedNotification, object: user?.levelProgression)
      }
    }
  }
  
  
}
