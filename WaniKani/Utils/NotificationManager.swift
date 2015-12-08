//
//  NotificationManager.swift
//
//
//  Created by Andriy K. on 8/12/15.
//
//

import UIKit
import Crashlytics


class NotificationManager: NSObject {
  
  static let sharedInstance = NotificationManager()
  
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
  
  func scheduleNextReviewNotification(date: NSDate) -> Bool {
    
    var newNotificationScheduled = false
    
    if notificationsEnabled {
      
      if UIApplication.sharedApplication().scheduledLocalNotifications!.count == 0 {
        if date.compare(NSDate()) == .OrderedDescending {
          let notification = UILocalNotification()
          notification.fireDate = date
          notification.alertBody = "New reviews available!"
          notification.soundName = "notification.m4a"
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
    
    lastAttemptDate = date
    return newNotificationScheduled
  }
  
  func unscheduleNotification() {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  
  
}
