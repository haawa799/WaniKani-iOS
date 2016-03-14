//
//  GetUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetKanjiListOperation: GroupOperation {
  
  let downloadOperation: DownloadKanjiListOperation
  let parseOperation: ParseKanjiListOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: KanjiListResponseHandler) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("\(cacheFilePrefix)_kanjiList_\(level).json")
    
    let url = NSURL(string: "\(baseURL)/kanji/\(level)")!
    downloadOperation = DownloadKanjiListOperation(url: url, cacheFile: cacheFile)
    parseOperation = ParseKanjiListOperation(cacheFile: cacheFile, handler: handler)
    parseOperation.addDependency(downloadOperation)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Kanji List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}