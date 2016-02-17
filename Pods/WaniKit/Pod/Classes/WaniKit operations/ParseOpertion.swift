//
//  ParseOpertion.swift
//  Pods
//
//  Created by Andriy K. on 12/27/15.
//
//

import Foundation


public class ParseOperation <T> : Operation {
  
  public typealias ResponseHandler = (Result<T, NSError>) -> Void
  
  private let cacheFile: NSURL
  private var handler: ResponseHandler
  
  public init(cacheFile: NSURL, handler: ResponseHandler ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
  }
  
  override func execute() {
    
    func throwAnError() {
      let error = NSError(domain: "Error reading data", code: 0, userInfo: nil)
      handler(Result.Error({error}))
      finish()
    }
    
    
    guard let stream = NSInputStream(URL: cacheFile) else {
      throwAnError()
      return
    }
    stream.open()
    
    defer {
      stream.close()
    }
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: []) as? NSDictionary
      
      if let parsedResult = parsedValue(json) {
        handler(Result.Response({parsedResult}))
        finish()
      } else {
        throwAnError()
      }
    }
    catch _ {
      throwAnError()
    }
  }
  
  func parsedValue(rootDictionary: NSDictionary?) -> T? {
    return nil
  }
  
}