//
//  GetUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import UIKit


public class GetCriticalItemsOperation: GroupOperation {
  
  let downloadOperation: DownloadCriticalItemsOperation
  let parseOperation: ParseCriticalItemsOperation
  
  init(baseURL: String, percentage: Int, cacheFilePrefix: String?, handler: CriticalItemsResponseHandler) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("\(cacheFilePrefix)_criticalItems_\(percentage).json")
    
    let url = NSURL(string: "\(baseURL)/critical-items/\(percentage)")!
    downloadOperation = DownloadCriticalItemsOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseCriticalItemsOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Critical items List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}