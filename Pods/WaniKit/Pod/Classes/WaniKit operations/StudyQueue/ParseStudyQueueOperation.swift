//
//  ParseStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public typealias StudyQueueRecieveBlock = (userInfo: UserInfo?, studyQInfo: StudyQueueInfo?) -> Void

public class ParseStudyQueueOperation: Operation {
  
  private let cacheFile: NSURL
  private var handler: StudyQueueRecieveBlock
  
  public init(cacheFile: NSURL, handler: StudyQueueRecieveBlock ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
    name = "Parse StudyQueue"
  }
  
  override func execute() {
    guard let stream = NSInputStream(URL: cacheFile) else {
      finish()
      return
    }
    stream.open()
    
    defer {
      stream.close()
    }
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: []) as? [String: AnyObject]
      
      var user: UserInfo?
      var studyQ: StudyQueueInfo?
      if let userInfo = json?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
        user = UserInfo(dict: userInfo)
      }
      if let studyQInfo = json?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
        studyQ = StudyQueueInfo(dict: studyQInfo)
      }
      handler(userInfo: user, studyQInfo: studyQ)
      finish()
    }
    catch let jsonError as NSError {
      finishWithError(jsonError)
    }
  }
  
}
