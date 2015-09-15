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

class DataFetchManager: NSObject {
  
  static let sharedInstance = DataFetchManager()
  
  static let newStudyQueueReceivedNotification = "NewStudyQueueReceivedNotification"
  
  func fetchStudyQueue(completionHandler: ((result: UIBackgroundFetchResult)->())? ) {
    WaniApiManager.sharedInstance.fetchStudyQueue { (user, studyQ, error) -> () in
      if error != nil {
        completionHandler?(result: UIBackgroundFetchResult.Failed)
        return
      }
      
      var newNotification = false
      
      if let user = user, let studyQ = studyQ {
        let realm = try! Realm()
        
        user.studyQueue = studyQ
        
        try! realm.write({ () -> Void in
          realm.add(user, update: true)
        })
        realm.refresh()
        
        let users = realm.objects(User)
        print(users)
        if let user = users.first, let q = user.studyQueue {
          
          newNotification = NotificationManager.sharedInstance.scheduleNextReviewNotification(q.nextReviewDate)
          let newAppIconCounter = q.reviewsAvaliable + q.lessonsAvaliable
          let oldAppIconCounter = UIApplication.sharedApplication().applicationIconBadgeNumber
          newNotification = newNotification || (oldAppIconCounter != newAppIconCounter)
          UIApplication.sharedApplication().applicationIconBadgeNumber = newAppIconCounter
          NSNotificationCenter.defaultCenter().postNotificationName(DataFetchManager.newStudyQueueReceivedNotification, object: q)
        }
        if newNotification {
          completionHandler?(result: UIBackgroundFetchResult.NewData)
        } else {
          completionHandler?(result: UIBackgroundFetchResult.NoData)
        }
      }
    }
  }
  
}
