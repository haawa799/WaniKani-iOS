//
//  DownloadUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//


import UIKit

public class DownloadUserInfoOperation: DownloadOperation {
  
  typealias ErrorHandler = (errors: [NSError]) -> Void
  
  var errorHandler: ErrorHandler?
  
  override init(url: NSURL, cacheFile: NSURL) {
    super.init(url: url, cacheFile: cacheFile)
    name = "Download User info data"
  }
  
  override func finished(errors: [NSError]) {
    super.finished(errors)
    errorHandler?(errors: errors)
  }
  
}