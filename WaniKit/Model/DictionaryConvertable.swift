//
//  DictionaryConvertable.swift
//  WaniKani
//
//  Created by Andriy K. on 8/12/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import Foundation

protocol DictionaryConvertable {
  typealias T
  static func objectFromDictionary(dict: NSDictionary) -> T?
}