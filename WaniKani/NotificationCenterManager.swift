//
//  NotificationCenterManager.swift
//  WaniKani
//
//  Created by Andriy K. on 12/11/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

struct NotificationCenterManager {
  
  enum NotificationName: String {
    case NoApiKeyNotification
    case NewStudyQueueReceivedNotification
    case NewLevelProgressionReceivedNotification
    case UpdatedKanjiListNotification
    case CriticalItemsReceivedNotification
  }
  
  func postNotification(notification: NotificationName, object: AnyObject?) {
    NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: object)
  }
  
  func addObserver(observer: AnyObject, notification: NotificationName, selector: Selector) {
    NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: notification.rawValue, object: nil)
  }
  
  func removeObserver(observer: AnyObject) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
}
