//
//  GetUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import UIKit


public class GetUserInfoOperation: GroupOperation {
  
  let downloadOperation: DownloadUserInfoOperation
  let parseOperation: ParseUserInfoOperation
  
  init(apiKey: String, handler: UserInfoRecieveBlock) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("userInfo.json")
    
    
    let url = NSURL(string: "\(WaniKitConstants.URL.BaseURL)/user/\(apiKey)/user-information")!
    downloadOperation = DownloadUserInfoOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseUserInfoOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get User info"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}