//
//  ParseUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import UIKit


public typealias UserInfoRecieveBlock = (userInfo: UserInfo?) -> Void

public class ParseUserInfoOperation: Operation {
  
  private let cacheFile: NSURL
  private var handler: UserInfoRecieveBlock
  
  public init(cacheFile: NSURL, handler: UserInfoRecieveBlock ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
    name = "Parse User info"
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
      if let userInfo = json?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
        user = UserInfo(dict: userInfo)
      }
      handler(userInfo: user)
      finish()
    }
    catch let jsonError as NSError {
      finishWithError(jsonError)
    }
  }
  
}