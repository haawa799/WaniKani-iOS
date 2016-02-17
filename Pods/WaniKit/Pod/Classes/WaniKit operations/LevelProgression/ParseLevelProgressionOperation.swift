//
//  ParseLevelProgressionOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public typealias LevelProgressionResponse = (userInfo: UserInfo?, levelProgression: LevelProgressionInfo?)
public typealias LevelProgressionRecieveBlock = (Result<LevelProgressionResponse, NSError>) -> Void


public class ParseLevelProgressionOperation: ParseOperation<LevelProgressionResponse> {
  
  override init(cacheFile: NSURL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse LevelProgression"
  }
  
  override func parsedValue(rootDictionary: NSDictionary?) -> LevelProgressionResponse? {
    
    var user: UserInfo?
    var levelProgress: LevelProgressionInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    if let levelProgInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
      levelProgress = LevelProgressionInfo(dict: levelProgInfo)
    }
    
    return (user, levelProgress)
  }
}