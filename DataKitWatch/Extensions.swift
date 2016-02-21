//
//  Extensions.swift
//  WaniKani
//
//  Created by Andriy K. on 2/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

public extension KanjiUpdateObject {
  
  public class func kanjiUpdateObjectFrom(data: NSData) -> KanjiUpdateObject? {
    NSKeyedUnarchiver.setClass(KanjiUpdateObject.self, forClassName: "DataKit.KanjiUpdateObject")
    NSKeyedUnarchiver.setClass(KanjiMainData.self, forClassName: "DataKit.KanjiMainData")
    
    let update = NSKeyedUnarchiver.unarchiveObjectWithData(data)
    let kanjiUpdate = update as? KanjiUpdateObject
    return kanjiUpdate
  }
  
}