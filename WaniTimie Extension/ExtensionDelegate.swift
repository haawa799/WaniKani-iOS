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

extension ExtensionDelegate: WCSessionDelegate {
  
  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
    
    guard let updateData = userInfo["update"] as? NSData else { return }
    NSKeyedUnarchiver.setClass(KanjiUpdateObject.self, forClassName: "DataKit.KanjiUpdateObject")
    NSKeyedUnarchiver.setClass(KanjiMainData.self, forClassName: "DataKit.KanjiMainData")
    
    let update = NSKeyedUnarchiver.unarchiveObjectWithData(updateData)
    print("\(update)")
    
    guard let kanjiUpdate = update as? KanjiUpdateObject else { return }
    
    NSKeyedArchiver.archiveRootObject(kanjiUpdate, toFile: updatePath)
  }
  
  func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {

  }
}

let updatePath: String = {
  
  let fileManager = NSFileManager.defaultManager()
  let appGroupIdentifier = "group.com.haawa.WaniKani"
  
  let appGroupURL: NSURL = fileManager.containerURLForSecurityApplicationGroupIdentifier(appGroupIdentifier)!
  let path = appGroupURL.path! + "/levelKanji.bin"
  return path
}()

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


