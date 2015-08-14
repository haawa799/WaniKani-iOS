//
//  NotificationManager.swift
//  
//
//  Created by Andriy K. on 8/12/15.
//
//

import UIKit
import PermissionScope


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
  
  func scheduleNextReviewNotification(date: NSDate) {
    
    pscope.show(authChange: { (finished, results) -> Void in
      
      if results.first?.status == .Authorized {
        
        
        if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 {
          if date.compare(NSDate()) == .OrderedDescending {
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertBody = "New reviews avaliable!"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
          } else {
            
          }
        }
      }
      
    }) { (results) -> Void in
      
    }
  }
  
  
  
}
