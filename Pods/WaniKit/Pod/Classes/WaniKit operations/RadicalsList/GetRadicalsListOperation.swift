//
//  GetUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import UIKit


public class GetRadicalsListOperation: GroupOperation {
  
  let downloadOperation: DownloadRadicalsListOperation
  let parseOperation: ParseRadicalsListOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: RadicalsListResponseHandler) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("\(cacheFilePrefix)_radicalsList_\(level).json")
    
    let url = NSURL(string: "\(baseURL)/radicals/\(level)")!
    downloadOperation = DownloadRadicalsListOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseRadicalsListOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Radicals List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}