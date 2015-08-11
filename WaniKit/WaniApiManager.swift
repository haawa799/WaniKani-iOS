//
//  WaniApiManager.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//

import Alamofire

public class WaniApiManager: NSObject {
  
  public static let sharedInstance = WaniApiManager()
  
  private static let baseURL = "https://www.wanikani.com/api/"
  private static let myKey = "c6ce4072cf1bd37b407f2c86d69137e3"
  
  public func qqq() {
    Alamofire.request(.GET, "https://www.wanikani.com/api/user/c6ce4072cf1bd37b407f2c86d69137e3/study-queue", parameters: nil)
      .responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, JSON, _) -> Void in
        println(JSON)
    }
  }
  
}
