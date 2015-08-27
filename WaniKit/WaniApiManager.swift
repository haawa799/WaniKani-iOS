//
//  WaniApiManager.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//

import Alamofire
import RealmSwift


// Define your models like regular Swift classes
class Dog: Object {
  dynamic var name = ""
  dynamic var age = 0
}
class Person: Object {
  dynamic var name = ""
  dynamic var picture = NSData()
  let dogs = List<Dog>()
}

public class WaniApiManager: NSObject {
  
  public static let sharedInstance = WaniApiManager()
  
  private static let baseURL = "https://www.wanikani.com/api/"
  private static let userDefaulsKey = "WaniAPIManagerKey"
  private var myKey: String?
  
  public static let noApiKeyNotification = "NoApiKeyNotification"
  
  private func apiKey() -> String? {
    if let key = myKey {
      return key
    } else {
      myKey = NSUserDefaults.standardUserDefaults().objectForKey(WaniApiManager.userDefaulsKey) as? String
    }
    if let key = myKey {
      return key
    } else {
      NSNotificationCenter.defaultCenter().postNotificationName(WaniApiManager.noApiKeyNotification, object: nil)
      return nil
    }
  }
  
  public func setApiKey(key: String) {
    NSUserDefaults.standardUserDefaults().setObject(key, forKey: WaniApiManager.userDefaulsKey)
    NSUserDefaults.standardUserDefaults().synchronize()
    myKey = key
  }
  
  private static let userInfoKey = "user_information"
  private static let requestedInfo = "requested_information"
  
  var manager: Manager!
  
  public func fetchStudyQueue(handler:(User?, StudyQueue?)->()) {
    
    if let key = apiKey() {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      
      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
      configuration.timeoutIntervalForResource = 60 // seconds
      
      manager = Alamofire.Manager(configuration: configuration)
      manager.request(.GET, "https://www.wanikani.com/api/user/\(key)/study-queue", parameters: nil)
        .responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, response, JSON, error) -> Void in
          var user: User? = nil
          var studyQueue: StudyQueue? = nil
          if let dict = JSON as? NSDictionary {
            if let userInfo = dict[WaniApiManager.userInfoKey] as? NSDictionary {
              user = User.objectFromDictionary(userInfo)
            }
            if let studyQueueInfo = dict[WaniApiManager.requestedInfo] as? NSDictionary {
              studyQueue = StudyQueue.objectFromDictionary(studyQueueInfo)
            }
          }
          handler(user, studyQueue)
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      }
    }
  }
  
}
