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
  
  let newStudyQueueReceivedNotification = "NewStudyQueueReceivedNotification"
  
  func fetchStudyQueue() {
    WaniApiManager.sharedInstance.fetchStudyQueue { (user, studyQ) -> () in
      if let user = user, let studyQ = studyQ {
        let realm = Realm()
        
        user.studyQueue = studyQ
        
        realm.write({ () -> Void in
          realm.add(user, update: true)
        })
        
        let users = realm.objects(User)
        if let user = users.first, let q = user.studyQueue {
          
          let hours = q.nextReviewWaitingData().hours
          NotificationManager.sharedInstance.scheduleNextReviewNotification(q.nextReviewDate)
          UIApplication.sharedApplication().applicationIconBadgeNumber = q.reviewsAvaliable
          
          NSNotificationCenter.defaultCenter().postNotificationName(self.newStudyQueueReceivedNotification, object: q)
        }
      }
    }
  }
  
}
