//
//  AppDelegate.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift
import Realm


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let notificationCenterManager = NotificationCenterManager()
  let fabricManager = FabricEventsManager()
  let waniApiManager = WaniApiManager()
  
  var window: UIWindow?
  var isBackgroundFetching = false
  lazy var rootViewController: UIViewController = {
    let q = self.window?.rootViewController
    return q!
  }()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    DataFetchManager.sharedInstance.performMigrationIfNeeded()
    
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    if NSUserDefaults.standardUserDefaults().valueForKey(NotificationManager.notificationsAllowedKey) == nil {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: NotificationManager.notificationsAllowedKey)
    }
    
    waniApiManager.delegate = self
    waniApiManager.setApiKey("69b9b1f682946cbc42d251f41f2863d7")
    
    print(user)
    
    return true
  }
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    
    isBackgroundFetching = true
    
    DataFetchManager.sharedInstance.fetchStudyQueue() { (result) -> () in
      self.fabricManager.postBackgroundFetchEvent(result)
      self.isBackgroundFetching = false
      completionHandler(result)
    }
  }
}

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let realm = try! Realm()
let realmQueue = dispatch_get_main_queue()//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

var user: User? {
  return realm.objects(User).first
}

extension AppDelegate: WaniApiManagerDelegate {
  func apiKeyWasUsedBeforeItWasSet() {
    notificationCenterManager.postNotification(.NoApiKeyNotification, object: nil)
  }
}

