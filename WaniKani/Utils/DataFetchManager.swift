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
        let realm = Realm()
        
        user.studyQueue = studyQ
        
        realm.write({ () -> Void in
          realm.add(user, update: true)
        })
        realm.refresh()
        
        let users = realm.objects(User)
        println(users)
        if let user = users.first, let q = user.studyQueue {
          
          NotificationManager.sharedInstance.scheduleNextReviewNotification(q.nextReviewDate)
          newNotification = UIApplication.sharedApplication().applicationIconBadgeNumber == q.reviewsAvaliable
          UIApplication.sharedApplication().applicationIconBadgeNumber = q.reviewsAvaliable
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
