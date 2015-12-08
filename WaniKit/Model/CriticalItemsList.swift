//
//  CriticalItemsList.swift
//  WaniKani
//
//  Created by Andriy K. on 11/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import RealmSwift
import Realm

public struct CriticalItem {
  public let type: ReviewItemType
  public let item: ReviewItem
}

//public class CriticalItemsRealm: Object {
//  public var radicals = List<RadicalItem>()
//  public var kanji = List<KanjiItem>()
//  public var vocab = List<VocabItem>()
//}

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
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required public init() {
    super.init()
  }
  
  public func plainListSortedByPercentage() -> [CriticalItem] {
    var plainList = [CriticalItem]()
    for radical in radicals {
      plainList.append(CriticalItem(type: ReviewItemType.Radical, item: radical))
    }
    for kan in kanji {
      plainList.append(CriticalItem(type: ReviewItemType.Kanji, item: kan))
    }
    for word in vocab {
      plainList.append(CriticalItem(type: ReviewItemType.Vocabulary, item: word))
    }
    return plainList.sort() { return $0.item.percentage.caseInsensitiveCompare($1.item.percentage) == NSComparisonResult.OrderedAscending }
  }
}
