//
//  AppDelegate.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import UICKeyChainStore

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
  
  let apiKeyStoreKey = "WaniKaniApiKey"
  let keychain = UICKeyChainStore(service: "com.haawa.WaniKani")
  let firstRunDefaultsKey = "FirstRun"
  let firstRunValue = "1strun"
  
  var window: UIWindow?
  var isBackgroundFetching = false
  lazy var rootViewController: UIViewController = {
    let q = self.window?.rootViewController
    return q!
  }()
  
  private func cleanKeychainIfNeeded() {
    
    if (NSUserDefaults.standardUserDefaults().objectForKey(firstRunDefaultsKey) == nil) {
      keychain[apiKeyStoreKey] = nil
      NSUserDefaults.standardUserDefaults().setValue(firstRunValue, forKey: firstRunDefaultsKey)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  private func setupManagers() {
    notificationCenterManager = NotificationCenterManager()
    fabricManager = FabricEventsManager()
    waniApiManager = WaniApiManager()
    activityManager = UserActivityManager()
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    cleanKeychainIfNeeded()
    
    DataFetchManager.sharedInstance.makeInitialPreperations()
    
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    if NSUserDefaults.standardUserDefaults().valueForKey(NotificationManager.notificationsAllowedKey) == nil {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: NotificationManager.notificationsAllowedKey)
    }
    
    setupManagers()
    
    waniApiManager.delegate = self
    if let key = keychain[apiKeyStoreKey] {
      
      waniApiManager.setApiKey(key)
    }
    
    if #available(iOS 9.0, *) {
      if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
        handleShortcut(shortcutItem)
        return false
      }
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
    
    
    var index: Int
    
    switch shortcutType {
    case ShortcutIdentifier.Lessons: index = 0
    case ShortcutIdentifier.Review: index = 1
    }
    
    delay(1) { () -> () in
      if let tabBar = (self.rootViewController as? UITabBarController) {
        tabBar.selectedIndex = 0
        if let vc = tabBar.viewControllers?.first {
          vc.performSegueWithIdentifier("webSession", sender: index)
        }
      }
    }
    
    return true
  }
  
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    guard let kanjiChar = userActivity.userInfo?["kCSSearchableItemActivityIdentifier"] as? String else {
      return false
    }
    
    guard let kanji = realm().objects(Kanji).filter("character = '\(kanjiChar)'").first else { return false }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let nav = storyboard.instantiateViewControllerWithIdentifier("NavSearchedKanjiViewController") as? UINavigationController, let searchedKanjiVC = nav.topViewController as? SearchedKanjiViewController  else { return false }
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

