//
//  WaniApiManager.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//

import Alamofire
import RealmSwift


// MARK: - Constants
public struct WaniApiManagerConstants {
  public struct NotificationKey {
    public static let NoApiKey = "NoApiKeyNotification"
  }
  public struct URL {
    public static let BaseURL = "https://www.wanikani.com/api"
  }
  public struct NSUserDefaultsKeys {
    public static let WaniKaniApiKey = "WaniAPIManagerKey"
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

public class WaniApiManager: NSObject, Singltone {
  
  // MARK: - Singltone
  
  public static func sharedInstance() -> WaniApiManager {
    return instance
  }
  
  // MARK: - Public API
  
  public func setApiKey(key: String?) {
    if let key = key {
      NSUserDefaults.standardUserDefaults().setObject(key, forKey: WaniApiManagerConstants.NSUserDefaultsKeys.WaniKaniApiKey)
    } else {
      NSUserDefaults.standardUserDefaults().removeObjectForKey(WaniApiManagerConstants.NSUserDefaultsKeys.WaniKaniApiKey)
    }
    NSUserDefaults.standardUserDefaults().synchronize()
    myKey = key
  }
  
  public func fetchStudyQueue(handler:(User, StudyQueue) -> ()) throws {
    internalFetchStudyQueue { (user, queue, error) -> () in
      if error != nil {
        throw WaniApiError.ServerError
      } else {
        if let user = user, let queue = queue {
          handler(user, queue)
        } else {
          throw WaniApiError.ObjectSereliazationError
        }
      }
    }
  }
  
  public func fetchLevelProgression(handler:(User, LevelProgression) -> ()) throws {
    
    internalFetchLevelProgress { (user, levelProgression, error) -> () in
      if error != nil {
        throw WaniApiError.ServerError
      } else {
        if let user = user, let levelProgression = levelProgression {
          handler(user, levelProgression)
        } else {
          throw WaniApiError.ObjectSereliazationError
        }
      }
    }
  }
  
  public func apiKey() -> String? {
    
    if let key = myKey {
      return key
    } else {
      myKey = NSUserDefaults.standardUserDefaults().objectForKey(WaniApiManagerConstants.NSUserDefaultsKeys.WaniKaniApiKey) as? String
    }
    if let key = myKey {
      return key
    } else {
      NSNotificationCenter.defaultCenter().postNotificationName(WaniApiManagerConstants.NotificationKey.NoApiKey, object: nil)
      return nil
    }
  }
  
  // MARK: Private
  
  private static let instance = WaniApiManager()
  private var manager: Manager!
  private var myKey: String?
  
  private func internalFetchStudyQueue(handler:(User?, StudyQueue?, error: ErrorType?) throws -> ()) {
    
    if let key = apiKey() {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      
      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
      configuration.timeoutIntervalForResource = 60
      
      manager = Alamofire.Manager(configuration: configuration)
      manager.request(.GET, "\(WaniApiManagerConstants.URL.BaseURL)/user/\(key)/study-queue", parameters: nil)
        .responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, response, JSON) -> Void in
          
          switch JSON {
          case .Failure( _ , let error) :
            do {
              try handler(nil, nil, error: error)
            } catch _ {
              
            }
            return
          case .Success(let value) :
            var user: User? = nil
            var studyQueue: StudyQueue? = nil
            if let dict = value as? NSDictionary {
              if let userInfo = dict[WaniApiManagerConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
                user = User.objectFromDictionary(userInfo)
              }
              if let studyQueueInfo = dict[WaniApiManagerConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
                studyQueue = StudyQueue.objectFromDictionary(studyQueueInfo)
              }
            }
            try! handler(user, studyQueue, error: nil)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return
          }
      }
    }
  }
  
  private func internalFetchLevelProgress(handler:(User?, LevelProgression?, error: ErrorType?) throws -> ()) {
    
    if let key = apiKey() {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      
      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
      configuration.timeoutIntervalForResource = 60
      
      manager = Alamofire.Manager(configuration: configuration)//https://www.wanikani.com/api/user/c6ce4072cf1bd37b407f2c86d69137e3/level-progression
      manager.request(.GET, "\(WaniApiManagerConstants.URL.BaseURL)/user/\(key)/level-progression", parameters: nil)
        .responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, response, JSON) -> Void in
          
          switch JSON {
          case .Failure( _ , let error) :
            do {
              try handler(nil, nil, error: error)
            } catch _ {
              
            }
            return
          case .Success(let value) :
            var user: User? = nil
            var levelProgression: LevelProgression? = nil
            if let dict = value as? NSDictionary {
              if let userInfo = dict[WaniApiManagerConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
                user = User.objectFromDictionary(userInfo)
              }
              if let studyQueueInfo = dict[WaniApiManagerConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
                levelProgression = LevelProgression.objectFromDictionary(studyQueueInfo)
              }
            }
            try! handler(user, levelProgression, error: nil)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return
          }
      }
    }
  }
  
  private override init() {
    super.init()
  }
  
}
