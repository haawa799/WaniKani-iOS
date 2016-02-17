//
//  GetLevelProgressionOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public class GetLevelProgressionOperation: GroupOperation {
  
  let downloadOperation: DownloadLevelProgressionOperation
  let parseOperation: ParseLevelProgressionOperation
  
  init(baseURL: String, cacheFilePrefix: String?, handler: LevelProgressionRecieveBlock) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("\(cacheFilePrefix)_levelProgress.json")
    
    
    let url = NSURL(string: "\(baseURL)/level-progression")!
    downloadOperation = DownloadLevelProgressionOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseLevelProgressionOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Level progression"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}