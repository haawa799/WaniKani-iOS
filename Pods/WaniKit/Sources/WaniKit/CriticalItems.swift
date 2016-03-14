//
//  CriticalItems.swift
//  Pods
//
//  Created by Andriy K. on 2/17/16.
//
//

import Foundation

public enum ItemType: String {
  case Radical = "radical"
  case Kanji = "kanji"
  case Word = "vocabulary"
}

public struct CriticalItems: ArrayInitialization {
  
  public private(set) var radicals = [RadicalInfo]()
  public private(set) var kanji = [KanjiInfo]()
  public private(set) var vocab = [WordInfo]()
  
  private static let keyType = "type"
  
  public init(array: NSArray) {
    
    radicals = [RadicalInfo]()
    kanji = [KanjiInfo]()
    vocab = [WordInfo]()
    
    for item in array {
      
      guard let dict = item as? NSDictionary,
        let typeString = dict[CriticalItems.keyType] as? String,
        let type = ItemType(rawValue: typeString) else {
          
          print("RRR")
          continue
      }
      
      switch type {
      case .Radical:
        let radical = RadicalInfo(dict: dict)
        radicals.append(radical)
      case .Kanji:
        let kanjiItm = KanjiInfo(dict: dict)
        kanji.append(kanjiItm)
      case .Word:
        let word = WordInfo(dict: dict)
        vocab.append(word)
      }
    }
  }
  
}