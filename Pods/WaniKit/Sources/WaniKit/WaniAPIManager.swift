//
//  WaniAPIManager.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation


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
  
  public var baseURL: String? {
    
    guard let apiKey = apiKey() else {
      return nil
    }
    return testBaseURL ?? "\(WaniKitConstants.URL.BaseURL)/user/\(apiKey)"
  }
  
  private var testBaseURL: String?
  private let identifier = NSUUID().UUIDString
  
  public init(testBaseURL: String? = nil) {
    self.testBaseURL = testBaseURL
  }
  
  public weak var delegate: WaniApiManagerDelegate?
  
  public private(set) var getStudyQueueOperation: GetStudyQueueOperation?
  public private(set) var getLevelProgressionOperation: GetLevelProgressionOperation?
  public private(set) var getUserInfoOperation: GetUserInfoOperation?
  public private(set) var getKanjiListOperation: GetKanjiListOperation?
  public private(set) var getRadicalsListOperation: GetRadicalsListOperation?
  public private(set) var getVocabListOperation: GetVocabListOperation?
  public private(set) var getCriticalItemsOperation: GetCriticalItemsOperation?
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
    guard let baseURL = baseURL else {
      return
    }
    
    if (getStudyQueueOperation == nil) || (getStudyQueueOperation?.finished == true) {
      getStudyQueueOperation = GetStudyQueueOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getStudyQueueOperation?.userInitiated = true
      operationQueue.addOperation(getStudyQueueOperation!)
    }
  }
  
  public func fetchLevelProgression(handler: LevelProgressionRecieveBlock) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getLevelProgressionOperation == nil) || (getLevelProgressionOperation?.finished == true) {
      getLevelProgressionOperation = GetLevelProgressionOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getLevelProgressionOperation?.userInitiated = true
      operationQueue.addOperation(getLevelProgressionOperation!)
    }
  }
  
  public func fetchUserInfo(handler: UserInfoResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getUserInfoOperation == nil) || (getUserInfoOperation?.finished == true) {
      getUserInfoOperation = GetUserInfoOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getUserInfoOperation?.userInitiated = true
      operationQueue.addOperation(getUserInfoOperation!)
    }
  }
  
  public func fetchKanjiList(level: Int, handler: KanjiListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getKanjiListOperation == nil) || (getKanjiListOperation?.finished == true) {
      getKanjiListOperation = GetKanjiListOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getKanjiListOperation?.userInitiated = true
      operationQueue.addOperation(getKanjiListOperation!)
    }
  }
  
  public func fetchRadicalsList(level: Int, handler: RadicalsListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getRadicalsListOperation == nil) || (getRadicalsListOperation?.finished == true) {
      getRadicalsListOperation = GetRadicalsListOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getRadicalsListOperation?.userInitiated = true
      operationQueue.addOperation(getRadicalsListOperation!)
    }
  }
  
  public func fetchVocabList(level: Int, handler: VocabListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getVocabListOperation == nil) || (getVocabListOperation?.finished == true) {
      getVocabListOperation = GetVocabListOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getVocabListOperation?.userInitiated = true
      operationQueue.addOperation(getVocabListOperation!)
    }
  }
  
  public func fetchCriticalItems(percentage: Int, handler: CriticalItemsResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getCriticalItemsOperation == nil) || (getCriticalItemsOperation?.finished == true) {
      getCriticalItemsOperation = GetCriticalItemsOperation(baseURL: baseURL, percentage: percentage, cacheFilePrefix: identifier, handler: handler)
      getCriticalItemsOperation?.userInitiated = true
      operationQueue.addOperation(getCriticalItemsOperation!)
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
