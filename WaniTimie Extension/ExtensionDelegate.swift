//
//  ExtensionDelegate.swift
//  WaniTimie Extension
//
//  Created by Andriy K. on 2/18/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import WatchKit
import WatchConnectivity
import DataKitWatch

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  func applicationDidFinishLaunching() {
    // Perform any final initialization of your application.
    setupWatchConnectivity()
  }
  
  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }
  
  private func setupWatchConnectivity() {
    
    guard WCSession.isSupported() else { return }
    
    let session  = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
  }
  
}


extension ExtensionDelegate: WCSessionDelegate {
  
  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
  guard let kanjiData = userInfo["hi"] as? NSData else { return }
    NSKeyedUnarchiver.setClass(KanjiMainData.self, forClassName: "DataKit.KanjiMainData")
    if let kanji = NSKeyedUnarchiver.unarchiveObjectWithData(kanjiData) {
      print("\(kanji.character)")
    }
  }
}

