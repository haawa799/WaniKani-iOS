//
//  CriticalItemsList.swift
//  WaniKani
//
//  Created by Andriy K. on 11/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import RealmSwift

public class CriticalItemsList: Object, ArrayInitialization {
  
  // Dictionary keys
  private static let keyType = "type"
  
  // Fields
  public var radicals = List<RadicalItem>()
  public var kanji = List<KanjiItem>()
  public var vocab = List<VocabItem>()
  
  required public init(array: NSArray) {
    super.init()
    
    for elem in array {
      if let dict = elem as? NSDictionary {
        
        guard let typeString = (dict[CriticalItemsList.keyType] as? String) else {return}
        let type = ReviewItemType(string: typeString)
        
        switch type {
        case .Radical: radicals.append(RadicalItem(dict: dict))
        case .Kanji: kanji.append(KanjiItem(dict: dict))
        case .Vocabulary: vocab.append(VocabItem(dict: dict))
        }
      }
    }
  }

  required public init() {
    super.init()
  }
}
