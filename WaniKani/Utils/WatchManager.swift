//
//  WatchManager.swift
//  WaniKani
//
//  Created by Andriy K. on 2/19/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation
import WatchConnectivity
import RealmSwift
import DataKit

extension AppDelegate {
  
  func setupWatchConnectivity() {
    
    guard #available(iOS 9.0, *) else { return }
    guard WCSession.isSupported() else { return }
    
    let session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
  }
}

@available(iOS 9.0, *)
extension AppDelegate: WCSessionDelegate {
  
  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    
  }
  
  func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {
    
  }
  
  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
    
  }
  
  func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
    
  }
}

extension AppDelegate {
  
  func sendThisLevelKanjiData() {
    
    guard #available(iOS 9.0, *) else { return }
    guard let user = user else { return }
    let session = WCSession.defaultSession()
    guard session.watchAppInstalled else { return }
    
    let kanji = realm.objects(Kanji).filter { return $0.level == user.level }
    
    
    
    for k in kanji {
      let mainData = k.mainData
      let data = NSKeyedArchiver.archivedDataWithRootObject(mainData)
      session.transferUserInfo(["hi" : data])
    }
    
  }
  
}
