//
//  NotificationManager.swift
//
//
//  Created by Andriy K. on 8/12/15.
//
//

import UIKit
import PermissionScope
import Crashlytics


class NotificationManager: NSObject {
  
  static let sharedInstance = NotificationManager()
  private let pscope: PermissionScope = {
    let p = PermissionScope()
    p.addPermission(PermissionConfig(type: .Notifications, demands: .Required, message: "We will only send you notification when Reviews are up. No spam."))
    p.headerLabel.text = "₍ᐢ•ﻌ•ᐢ₎*･ﾟ｡"
    p.bodyLabel.text = "This app works best with notifications."
    p.bodyLabel.superview?.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    return p
    }()
  
  
  
  static let notificationsAllowedKey = "NotificationsAllowedKey"
  var notificationsEnabled = NSUserDefaults.standardUserDefaults().boolForKey(NotificationManager.notificationsAllowedKey) {
    didSet {
      if oldValue != notificationsEnabled {
        NSUserDefaults.standardUserDefaults().setBool(notificationsEnabled, forKey: NotificationManager.notificationsAllowedKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if notificationsEnabled == false {
          unscheduleNotification()
        } else {
          if let date = lastAttemptDate {
            scheduleNextReviewNotification(date)
          }
        }
      }
    }
  }
  private var lastAttemptDate: NSDate?
  
  //return NSUserDefaults.standardUserDefaults().boolForKey(notificationsAllowedKey)
  
  func scheduleNextReviewNotification(date: NSDate) -> Bool {
    
    var newNotificationScheduled = false
    
    if notificationsEnabled {
      pscope.show(authChange: { (finished, results) -> Void in
        if results.first?.status == .Authorized {
          if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 {
            if date.compare(NSDate()) == .OrderedDescending {
              let notification = UILocalNotification()
              notification.fireDate = date
              notification.alertBody = "New reviews avaliable!"
              UIApplication.sharedApplication().scheduleLocalNotification(notification)
              newNotificationScheduled = true
              
              var backgroundCall = false
              if let isBackgroundFetch = (UIApplication.sharedApplication().delegate as? AppDelegate)?.isBackgroundFetching {
                backgroundCall = isBackgroundFetch
              }
              Answers.logCustomEventWithName("Notification scheduled",
                customAttributes: [
                  "isBackgroundFetch": "\(backgroundCall)"
                ])
            } else {
            }
          }
        }
        
        }) { (results) -> Void in
          
      }
    }
    lastAttemptDate = date
    return newNotificationScheduled
  }
  
  func unscheduleNotification() {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  
  
}
