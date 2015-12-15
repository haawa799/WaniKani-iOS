//
//  WaniAPIManager.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

// MARK: - Constants
public struct WaniKitConstants {
  public struct URL {
    public static let BaseURL = "https://www.wanikani.com/api"
  }
  public struct ResponseKeys {
    public static let UserInfoKey = "user_information"
    public static let RequestedInfoKey = "requested_information"
  }
}

public enum WaniApiError: ErrorType {
  case ServerError
  case ObjectSereliazationError
}

public protocol WaniApiManagerDelegate: class {
  func apiKeyWasUsedBeforeItWasSet()
  func apiKeyWasSet()
}

public class WaniApiManager {
  
  public init() {
    
  }
  
  public weak var delegate: WaniApiManagerDelegate?
  
  public private(set) var getStudyQueueOperation: GetStudyQueueOperation?
  public private(set) var getLevelProgressionOperation: GetLevelProgressionOperation?
  public private(set) var getUserInfoOperation: GetUserInfoOperation?
  public private(set) var operationQueue: OperationQueue = {
    let q = OperationQueue()
    q.maxConcurrentOperationCount = 1
    return q
  }()
  
  // MARK: - Public API
  
  public func setApiKey(key: String?) {
    myKey = key
    if key != nil {
      delegate?.apiKeyWasSet()
    }
  }
  
  public func fetchStudyQueue(handler: StudyQueueRecieveBlock) {
    guard let apiKey = apiKey() else {
      return
    }
    
    if (getStudyQueueOperation == nil) || (getStudyQueueOperation?.finished == true) {
      getStudyQueueOperation = GetStudyQueueOperation(apiKey: apiKey, handler: handler)
      getStudyQueueOperation?.userInitiated = true
      operationQueue.addOperation(getStudyQueueOperation!)
    }
  }
  
  public func fetchLevelProgression(handler: LevelProgressionRecieveBlock) {
    guard let apiKey = apiKey() else {
      return
    }
    
    if (getLevelProgressionOperation == nil) || (getLevelProgressionOperation?.finished == true) {
      getLevelProgressionOperation = GetLevelProgressionOperation(apiKey: apiKey, handler: handler)
      getLevelProgressionOperation?.userInitiated = true
      operationQueue.addOperation(getLevelProgressionOperation!)
    }
  }
  
  public func fetchUserInfo(handler: UserInfoRecieveBlock) {
    guard let apiKey = apiKey() else {
      return
    }
    
    if (getUserInfoOperation == nil) || (getUserInfoOperation?.finished == true) {
      getUserInfoOperation = GetUserInfoOperation(apiKey: apiKey, handler: handler)
      getUserInfoOperation?.userInitiated = true
      operationQueue.addOperation(getUserInfoOperation!)
    }
  }
  
  public func apiKey() -> String? {
    if myKey == nil {
      delegate?.apiKeyWasUsedBeforeItWasSet()
    }
    return myKey
  }
  
  // MARK: Private
  private var myKey: String?
  
}
