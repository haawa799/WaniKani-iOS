//
//  AppDelegate.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  static let bgFetchUserDefaultKey = "backgroundFetch"
  static let bgFetchDatesUserDefaultKey = "backgroundFetchDates"
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    if NSUserDefaults.standardUserDefaults().valueForKey(NotificationManager.notificationsAllowedKey) == nil {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: NotificationManager.notificationsAllowedKey)
    }
    
    Crashlytics.sharedInstance().debugMode = true
    Crashlytics.startWithAPIKey("d2e6cfd499572eade933f1e9b057bb480b76a6bf")
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    DataFetchManager.sharedInstance.fetchStudyQueue()
  }
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    var counter = NSUserDefaults.standardUserDefaults().integerForKey(AppDelegate.bgFetchUserDefaultKey)
    counter++
    NSUserDefaults.standardUserDefaults().setInteger(counter, forKey: AppDelegate.bgFetchUserDefaultKey)
    
    var dates = NSUserDefaults.standardUserDefaults().arrayForKey(AppDelegate.bgFetchDatesUserDefaultKey) as? [NSDate]
    if dates == nil {
      dates = [NSDate]()
    }
    
    dates?.append(NSDate())
    NSUserDefaults.standardUserDefaults().setObject(dates, forKey: AppDelegate.bgFetchDatesUserDefaultKey)
    
    NSUserDefaults.standardUserDefaults().synchronize()
    
    DataFetchManager.sharedInstance.fetchStudyQueue { (result) -> () in
      completionHandler(result)
    }
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
}

