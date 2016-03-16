//
//  NotificationManager.swift
//
//
//  Created by Andriy K. on 8/12/15.
//
//

import UIKit
//import Crashlytics


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
    
    // Make sure notification is in future
    guard date.timeIntervalSinceNow > 0 else { return false }
    
    var newNotificationScheduled = false
    
    if notificationsEnabled {
      
      // Clean up past notifications
      if UIApplication.sharedApplication().scheduledLocalNotifications?.count > 0 {
        for notif in UIApplication.sharedApplication().scheduledLocalNotifications! {
          if notif.fireDate?.timeIntervalSinceNow < 0 {
            unscheduleNotification()
            break
          }
        }
      }
      
      // Schedule new notification if there is none yet
      if UIApplication.sharedApplication().scheduledLocalNotifications?.count == 0 {
        if date.compare(NSDate()) == .OrderedDescending {
          print("orderDescending")
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
          appDelegate.fabricManager.postNotificationScheduled(backgroundCall)
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
