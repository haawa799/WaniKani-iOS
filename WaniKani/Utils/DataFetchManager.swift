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
    
    WaniApiManager.sharedInstance().fetchStudyQueue { (userInfo, studyQInfo) -> Void in
      
      guard let userInfo = userInfo, studyQInfo = studyQInfo else {
        completionHandler?(result: UIBackgroundFetchResult.Failed)
        return
      }
      
      // Convert to Realm objects
      let user = User(userInfo: userInfo)
      let studyQ = StudyQueue(studyQueueInfo: studyQInfo)
      
      var newNotification = false
      let realm = try! Realm()
      self.updateUserInRealm(user, submitToGC: false, modificationBlock: { (realmUser) -> () in
        realmUser.studyQueue = studyQ
      })
      
      let users = realm.objects(User)
      if let user = users.first, let q = user.studyQueue /*where PermissionScope().statusNotifications() == .Authorized*/ {
        
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
  
  func fetchLevelProgression() {
    
    WaniApiManager.sharedInstance().fetchLevelProgression { (userInfo, levelProgressionInfo) -> Void in
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
    
    var oldLevel = 0
    let newLevel = user.level
    
    let realm = try! Realm()
    
    var realmUser: User
    if let currentUSer = realm.objects(User).first {
      realmUser = currentUSer
      oldLevel = realmUser.level
    } else {
      try! realm.write({ () -> Void in
        realm.add(user)
      })
      realmUser = user
    }
    
    try! realm.write({ () -> Void in
      realmUser.gravatar = user.gravatar
      realmUser.level = user.level
      realmUser.title = user.title
      realmUser.about = user.about
      realmUser.website = user.website
      realmUser.twitter = user.twitter
      realmUser.topicsCount = user.topicsCount
      realmUser.postsCount = user.postsCount
      modificationBlock?(realmUser: realmUser)
      realm.add(realmUser, update: true)
    })
    realm.refresh()
    
    if submitToGC {
      AwardsManager.sharedInstance.userLevelUp(oldLevel: oldLevel, newLevel: newLevel)
    }
  }
  
}
