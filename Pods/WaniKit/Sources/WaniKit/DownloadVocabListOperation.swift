//
//  DownloadUserInfoOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//


import Foundation

public class DownloadVocabListOperation: DownloadOperation {
  
  override init(url: NSURL, cacheFile: NSURL) {
    
    super.init(url: url, cacheFile: cacheFile)
    name = "Download Vocab info data"
  }
  
}