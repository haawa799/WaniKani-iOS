//
//  DictionaryConvertable.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

protocol DictionaryConvertable {
  typealias T
  static func entityFromDictionary(dict: NSDictionary) -> T?
}

public protocol DictionaryInitialization {
  init(dict: NSDictionary)
}

protocol ArrayInitialization {
  init(array: NSArray)
}

public func performWithDelay(delay: Double, closure: () -> Void) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}