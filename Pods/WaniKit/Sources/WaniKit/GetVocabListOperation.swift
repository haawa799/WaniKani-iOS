//
//  GetUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetVocabListOperation: GroupOperation {
  
  let downloadOperation: DownloadVocabListOperation
  let parseOperation: ParseVocabListOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: VocabListResponseHandler) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("\(cacheFilePrefix)_vocabList_\(level).json")
    
    let url = NSURL(string: "\(baseURL)/vocabulary/\(level)")!
    downloadOperation = DownloadVocabListOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseVocabListOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Vocab List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}