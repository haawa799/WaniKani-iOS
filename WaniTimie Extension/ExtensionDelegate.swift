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
    setupWatchConnectivity()
  }
  
  func setupWatchConnectivity() {
    
    guard WCSession.isSupported() else { return }
    let session  = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
    
    requestInitialInfoIfNeeded()
  }
  
  private func requestInitialInfoIfNeeded() {
    let curLevel = dataManager.currentLevel?.kanji.first?.level ?? 0
    let session  = WCSession.defaultSession()
    session.sendMessage([Communication.myLevel: curLevel], replyHandler: nil) { (error) -> Void in
      print(error)
    }
  }
  
}

extension ExtensionDelegate: WCSessionDelegate {
  
  func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
    guard let updateData = userInfo[Communication.newCurrentLevelUpdate] as? NSData else { return }
    guard let kanjiUpdate = KanjiUpdateObject.kanjiUpdateObjectFrom(updateData) else { return }
    dataManager.updateCurrentLevelKanji(kanjiUpdate)
  }
}

let dataManager = DataManager()