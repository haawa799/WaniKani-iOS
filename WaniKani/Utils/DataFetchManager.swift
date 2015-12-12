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
        //        if (oldSchemaVersion < 1) {
        //          migration.enumerate(User.className()) { oldObject, newObject in
        //            // combine name fields into a single field
        //          }
        //        }
    })
    _ = try! Realm()
  }
  
  func fetchAllData() {
    fetchStudyQueue(nil)
    fetchLevelProgression()
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
            let usr = User(userInfo: userInfo)
            let studyQ = StudyQueue(studyQueueInfo: studyQInfo)
            dispatch_async(realmQueue) { () -> Void in
              try! realm.write({ () -> Void in
                usr.studyQueue = studyQ
                realm.add(usr)
              })
            }
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
      
      
//      let studyQ = StudyQueue(studyQueueInfo: studyQInfo)
////
//      let realm = try! Realm()
//      let users = realm.objects(User)
//
//      if let usr = users.first {
//        self.updateUserInRealm(usr, submitToGC: false, modificationBlock: { (realmUser) -> () in
//          realmUser.updateUserWithUserInfo(userInfo)
//          realmUser.studyQueue = studyQ
//        })
//      } else {
//        let usr = User(userInfo: userInfo)
//        usr.studyQueue = studyQ
//        try! realm.write({ () -> Void in
//          realm.add(usr)
//        })
//      }
    }
  }
  
  func fetchLevelProgression() {
    
    appDelegate.waniApiManager.fetchLevelProgression { (userInfo, levelProgressionInfo) -> Void in
      guard let userInfo = userInfo, levelProgressionInfo = levelProgressionInfo else {
        return
      }
      
      // Convert to Realm objects
      let user = User(userInfo: userInfo)
      let levelProgression = LevelProgression(levelProgressInfo: levelProgressionInfo)
      
      self.updateUserInRealm(user, submitToGC: true, modificationBlock: { (realmUser) -> () in
        realmUser.levelProgression = levelProgression
      })
      appDelegate.notificationCenterManager.postNotification(.NewLevelProgressionReceivedNotification, object: levelProgression)
    }
  }
  
//  func fetchCriticalItems() {
//    do {
//      
//      try WaniApiManager.sharedInstance().fetchCriticalItems({ (user, criticalItems) -> () in
//        self.updateUserInRealm(user, submitToGC: false, modificationBlock: { (realmUser) -> () in
//          realmUser.criticalItems = criticalItems
//        })
//        NSNotificationCenter.defaultCenter().postNotificationName(DataFetchManager.criticalItemsReceivedNotification, object: criticalItems)
//      })
//    } catch {
//      
//    }
//  }
  
  typealias UserModificationBlock = (realmUser: User)->()
  
  func updateUserInRealm(user: User, submitToGC: Bool, modificationBlock: UserModificationBlock?) {
    
//    var oldLevel = 0
//    let newLevel = user.level
//    
//    let realm = try! Realm()
//    
//    var realmUser: User
//    if let currentUSer = realm.objects(User).first {
//      realmUser = currentUSer
//      oldLevel = realmUser.level
//    } else {
//      try! realm.write({ () -> Void in
//        realm.add(user)
//      })
//      realmUser = user
//    }
//    
//    try! realm.write({ () -> Void in
//      realmUser.gravatar = user.gravatar
//      realmUser.level = user.level
//      realmUser.title = user.title
//      realmUser.about = user.about
//      realmUser.website = user.website
//      realmUser.twitter = user.twitter
//      realmUser.topicsCount = user.topicsCount
//      realmUser.postsCount = user.postsCount
//      modificationBlock?(realmUser: realmUser)
//      realm.add(realmUser, update: true)
//    })
//    realm.refresh()
//    
//    if submitToGC {
//      AwardsManager.sharedInstance.userLevelUp(oldLevel: oldLevel, newLevel: newLevel)
//    }
  }
  
}
