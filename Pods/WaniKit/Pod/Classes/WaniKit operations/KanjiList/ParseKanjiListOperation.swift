//
//  ParseUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import UIKit


public typealias KanjiListResponse = (userInfo: UserInfo?, kanji: [KanjiInfo]?)
public typealias KanjiListResponseHandler = (Result<KanjiListResponse, NSError>) -> Void

public class ParseKanjiListOperation: ParseOperation<KanjiListResponse> {
  
  override init(cacheFile: NSURL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse Kanji list"
  }
  
  override func parsedValue(rootDictionary: NSDictionary?) -> KanjiListResponse? {
    
    var user: UserInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    
    var kanji: [KanjiInfo]?
    if let requestedInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? [NSDictionary] {
      kanji = requestedInfo.map({ (dict) -> KanjiInfo in
        return KanjiInfo(dict: dict)
      })
    }
    
    return (user, kanji)
  }
  
}
