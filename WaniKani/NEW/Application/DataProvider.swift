//
//  DataProvider.swift
//  WaniKani
//
//  Created by Andriy K. on 3/22/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift
import Realm

typealias ProgressionBlock = (User?, LevelProgression?) -> ()
typealias StudyQueueBlock = (User?, StudyQueue?) -> ()
typealias RequestErrorBlock = (ErrorType?) -> ()

struct DataProvider {
  
  enum NotificationName: String {
    case NewLevelProgressionReceivedNotification
    case NewStudyQueueReceivedNotification
    case NewUserInfoReceivedNotification
  }
  
  private let waniApiManager: WaniApiManager = {
    let manager = WaniApiManager()
    manager.setApiKey("c6ce4072cf1bd37b407f2c86d69137e3")
    return manager
  }()
  
}

// MARK: - Public API
extension DataProvider {
  
  // MARK: Level progression
  func fetchLastStoredProgression(handler: ProgressionBlock) {
    let oldUser = realm.objects(User).first
    let oldProgression = oldUser?.levelProgression
    handler(oldUser, oldProgression)
  }
  
  func fetchNewProgression(errorHandler: RequestErrorBlock) {
    waniApiManager.fetchLevelProgression { result -> Void in
      switch result {
      case .Error(let error): errorHandler(error())
      case .Response(let response):
        let resp = response()
        let userInfo = resp.userInfo
        let levelProgressionInfo = resp.levelProgression
        self.saveNewProgressionToRealm(userInfo, levelProgressionInfo: levelProgressionInfo)
      }
    }
  }
  
  // MARK: Study queue
  func fetchLastStoredStudyQ(handler: StudyQueueBlock) {
    let oldUser = realm.objects(User).first
    let oldStudyQueue = oldUser?.studyQueue
    handler(oldUser, oldStudyQueue)
  }
  
  func fetchNewStudyQ(errorHandler: RequestErrorBlock) {
    waniApiManager.fetchStudyQueue { (result) in
      switch result {
      case .Error(let error): errorHandler(error())
      case .Response(let response):
        let resp = response()
        let userInfo = resp.userInfo
        let studyQueueInfo = resp.studyQInfo
        self.saveNewStudyQueueToRealm(userInfo, studyQueueInfo: studyQueueInfo)
      }
    }
  }
  
}

extension DataProvider {
  
  private func saveNewProgressionToRealm(userInfo: UserInfo?, levelProgressionInfo: LevelProgressionInfo?) {
    dispatch_async(realmQueue) { () -> Void in
      guard let user = realm.objects(User).first, let progression = user.levelProgression else { return }
      try! realm.write({ () -> Void in
        progression.updateWith(levelProgressionInfo)
        user.updateUserWithUserInfo(userInfo)
      })
      realm.refresh()
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        realm.refresh()
        let user = realm.objects(User).first
        let levelProgression =  user?.levelProgression
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(NotificationName.NewUserInfoReceivedNotification.rawValue, object: user)
        notificationCenter.postNotificationName(NotificationName.NewLevelProgressionReceivedNotification.rawValue, object: levelProgression)
      })
    }
  }
  
  private func saveNewStudyQueueToRealm(userInfo: UserInfo?, studyQueueInfo: StudyQueueInfo?) {
    dispatch_async(realmQueue) { () -> Void in
      guard let user = realm.objects(User).first, let studyQueue = user.studyQueue else { return }
      try! realm.write({ () -> Void in
        studyQueue.updateWith(studyQueueInfo)
        user.updateUserWithUserInfo(userInfo)
      })
      realm.refresh()
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        realm.refresh()
        let user = realm.objects(User).first
        let studyQueue = user?.studyQueue
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(NotificationName.NewUserInfoReceivedNotification.rawValue, object: user)
        notificationCenter.postNotificationName(NotificationName.NewStudyQueueReceivedNotification.rawValue, object: studyQueue)
      })
    }
  }
}