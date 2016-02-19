//
//  AppDelegate.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import DataKit

enum ShortcutIdentifier: String {
  case Lessons
  case Review
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private(set) var notificationCenterManager: NotificationCenterManager!
  private(set) var fabricManager: FabricEventsManager!
  private(set) var waniApiManager: WaniApiManager!
  private(set) var activityManager: UserActivityManager!
  private(set) var keychainManager: KeychainManager!
  
  
  var window: UIWindow?
  var isBackgroundFetching = false
  
  private lazy var firstTabViewController: DashboardViewController = {
    return self.rootViewController.viewControllers?.first as! DashboardViewController
  }()
  
  lazy var rootViewController: UITabBarController = {
    return self.window?.rootViewController as! UITabBarController
  }()
  
  private func setupManagers() {
    notificationCenterManager = NotificationCenterManager()
    fabricManager = FabricEventsManager()
    waniApiManager = WaniApiManager()
    activityManager = UserActivityManager()
    keychainManager = KeychainManager()
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    setupManagers()
    
//    if NSUserDefaults.standardUserDefaults().boolForKey("FASTLANE_SNAPSHOT") {
      
//    }
    
    DataFetchManager.sharedInstance.makeInitialPreperations()
    
    let q = realm.objects(Kanji)
    print("appD kanji: \(q.count)")
    
    keychainManager.cleanKeychainIfNeeded()
    waniApiManager.delegate = self
    if let key = keychainManager.apiKey {
      waniApiManager.setApiKey(key)
    }
    
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    if NSUserDefaults.standardUserDefaults().valueForKey(NotificationManager.notificationsAllowedKey) == nil {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: NotificationManager.notificationsAllowedKey)
    }
    
    
    if #available(iOS 9.0, *) {
      if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
        handleShortcut(shortcutItem)
        return false
      }
    }
    
    setupWatchConnectivity()
    
    delay(3) { () -> () in
      self.sendThisLevelKanjiData()
    }
    
    return true
  }
  
  @available(iOS 9.0, *)
  func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,completionHandler: (Bool) -> Void) {
    completionHandler(handleShortcut(shortcutItem))
  }
  
  @available(iOS 9.0, *)
  private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
    
    guard let shortcutType = ShortcutIdentifier(rawValue: shortcutItem.type) else { return false }
    
    delay(1) { () -> () in
      switch shortcutType {
      case ShortcutIdentifier.Lessons: self.firstTabViewController.openReviews()
      case ShortcutIdentifier.Review: self.firstTabViewController.openLessons()
      }
    }
    
    return true
  }
  
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    guard let kanjiChar = userActivity.userInfo?["kCSSearchableItemActivityIdentifier"] as? String else {
      return false
    }
    
    guard let kanji = realm.objects(Kanji).filter("character = '\(kanjiChar)'").first else { return false }
    let storyboard = UIStoryboard(name: "Data", bundle: nil)
    guard let nav = storyboard.instantiateViewControllerWithIdentifier("SearchKanjiViewController") as? UINavigationController, let searchedKanjiVC = nav.topViewController as? SearchedKanjiViewController  else { return false }
    searchedKanjiVC.kanjiInfo = kanji
    rootViewController.presentViewController(nav, animated: true, completion: nil)
    return false
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

extension AppDelegate: WaniApiManagerDelegate {
  func apiKeyWasUsedBeforeItWasSet() {
    notificationCenterManager.postNotification(.NoApiKeyNotification, object: nil)
  }
  
  func apiKeyWasSet() {
    
  }
  
}

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

