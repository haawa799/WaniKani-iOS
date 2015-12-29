//
//  DownloadOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public enum Result<T, U> {
  case Response(() -> T)
  case Error(() -> U)
}

public class DownloadOperation: GroupOperation {
  
  let cacheFile: NSURL
  
  init(url: NSURL, cacheFile: NSURL) {
    
    print(url)
    self.cacheFile = cacheFile
    
    super.init(operations: [])
    name = "Download Operation"
    //
    
    let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    
    let task = session.downloadTaskWithRequest(request) { (url, response, error) -> Void in
      self.downloadFinished(url, response: response, error: error)
    }
    
    let taskOperation = URLSessionTaskOperation(task: task)
    let reachabilityCondition = ReachabilityCondition(host: url)
    taskOperation.addCondition(reachabilityCondition)
    
    let networkObserver = NetworkObserver()
    taskOperation.addObserver(networkObserver)
    
    addOperation(taskOperation)
  }
  
  func downloadFinished(url: NSURL?, response: NSURLResponse?, error: NSError?) {
    
    if let localURL = url {
      do {
        try NSFileManager.defaultManager().removeItemAtURL(cacheFile)
      }
      catch { }
      
      do {
        try NSFileManager.defaultManager().moveItemAtURL(localURL, toURL: cacheFile)
      }
      catch let error as NSError {
        aggregateError(error)
      }
      
    }
    else if let error = error {
      aggregateError(error)
    }
    else {
      // Do nothing, and the operation will automatically finish.
    }
  }
  
}