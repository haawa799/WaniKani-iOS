//
//  ParseUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public typealias VocabListResponse = (userInfo: UserInfo?, vocab: [WordInfo]?)
public typealias VocabListResponseHandler = (Result<VocabListResponse, NSError>) -> Void

public class ParseVocabListOperation: ParseOperation<VocabListResponse> {
  
  override init(cacheFile: NSURL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse Vocab list"
  }
  
  override func parsedValue(rootDictionary: NSDictionary?) -> VocabListResponse? {
    
    var user: UserInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    
    var vocab: [WordInfo]?
    if let requestedInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? [NSDictionary] {
      vocab = requestedInfo.map({ (dict) -> WordInfo in
        return WordInfo(dict: dict)
      })
    }
    
    return (user, vocab)
  }
  
}
