//
//  ParseLevelProgressionOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public typealias LevelProgressionRecieveBlock = (userInfo: UserInfo?, levelProgression: LevelProgressionInfo?) -> Void

public class ParseLevelProgressionOperation: Operation {
  
  private let cacheFile: NSURL
  private var handler: LevelProgressionRecieveBlock
  
  public init(cacheFile: NSURL, handler: LevelProgressionRecieveBlock ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
    name = "Parse LevelProgression"
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
      var levelProgress: LevelProgressionInfo?
      if let userInfo = json?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
        user = UserInfo(dict: userInfo)
      }
      if let levelProgInfo = json?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
        levelProgress = LevelProgressionInfo(dict: levelProgInfo)
      }
      handler(userInfo: user, levelProgression: levelProgress)
      finish()
    }
    catch let jsonError as NSError {
      finishWithError(jsonError)
    }
  }
  
}
