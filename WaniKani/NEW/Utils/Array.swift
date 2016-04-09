//
//  Array.swift
//  WaniKani
//
//  Created by Andriy K. on 4/4/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
  
  // Remove first collection element that is equal to the given `object`:
  mutating func removeObject(object : Generator.Element) {
    if let index = self.indexOf(object) {
      self.removeAtIndex(index)
    }
  }
  
}