//
//  GetStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public class GetStudyQueueOperation: GroupOperation {
  
  let downloadOperation: DownloadStudyQueueOperation
  let parseOperation: ParseStudyQueueOperation
  
  init(apiKey: String, handler: StudyQueueRecieveBlock) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("studyQueue.json")
    
    
    let url = NSURL(string: "\(WaniKitConstants.URL.BaseURL)/user/\(apiKey)/study-queue")!
    downloadOperation = DownloadStudyQueueOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseStudyQueueOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Study Queue"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
