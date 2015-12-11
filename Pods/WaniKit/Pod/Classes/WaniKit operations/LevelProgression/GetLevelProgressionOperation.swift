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
  
  init(apiKey: String, handler: LevelProgressionRecieveBlock) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("levelProgress.json")
    
    
    let url = NSURL(string: "\(WaniKitConstants.URL.BaseURL)/user/\(apiKey)/level-progression")!
    downloadOperation = DownloadLevelProgressionOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseLevelProgressionOperation(cacheFile: cacheFile, handler: handler)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Level progression"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}