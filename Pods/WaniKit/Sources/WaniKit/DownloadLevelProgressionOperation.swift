//
//  DownloadLevelProgressionOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public class DownloadLevelProgressionOperation: DownloadOperation {
  
  override init(url: NSURL, cacheFile: NSURL) {
    
    super.init(url: url, cacheFile: cacheFile)
    name = "Download Level Progression data"
  }
  
}
