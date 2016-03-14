//
//  ParseUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public typealias RadicalsListResponse = (userInfo: UserInfo?, radicals: [RadicalInfo]?)
public typealias RadicalsListResponseHandler = (Result<RadicalsListResponse, NSError>) -> Void

public class ParseRadicalsListOperation: ParseOperation<RadicalsListResponse> {
  
  override init(cacheFile: NSURL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse Radicals list"
  }
  
  override func parsedValue(rootDictionary: NSDictionary?) -> RadicalsListResponse? {
    
    var user: UserInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    
    var radicals: [RadicalInfo]?
    if let requestedInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? [NSDictionary] {
      radicals = requestedInfo.map({ (dict) -> RadicalInfo in
        return RadicalInfo(dict: dict)
      })
    }
    
    return (user, radicals)
  }
  
}
