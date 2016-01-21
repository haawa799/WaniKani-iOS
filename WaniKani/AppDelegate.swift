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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private(set) lazy var notificationCenterManager = NotificationCenterManager()
  private(set) lazy var fabricManager = FabricEventsManager()
  private(set) lazy var waniApiManager = WaniApiManager()
  
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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    cleanKeychainIfNeeded()
    
    DataFetchManager.sharedInstance.makeInitialPreperations()
    
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    if NSUserDefaults.standardUserDefaults().valueForKey(NotificationManager.notificationsAllowedKey) == nil {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: NotificationManager.notificationsAllowedKey)
    }
    
    waniApiManager.delegate = self
    if let key = keychain[apiKeyStoreKey] {
      
      waniApiManager.setApiKey(key)
    }
    
    return true
  }
  
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    guard userActivity.activityType == Kanji.domainIdentifier,
      let kanjiChar = userActivity.userInfo?["id"] as? String else {
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

