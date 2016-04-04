//
//  AllKanjiHelper
//
//
//  Created by Andriy K. on 12/25/15.
//
//

import SQLite


#if os(iOS)
import UIKit
public typealias Path = UIBezierPath
#elseif os(OSX)
import AppKit
public typealias Path = NSBezierPath
#elseif os(tvOS)
import UIKit
public typealias Path = UIBezierPath
#endif


private class KanjiBundleSearch {}

public struct AllKanjiHelper {
  
  public static let podBundle: NSBundle? = {
    
    let bundle0 = NSBundle(forClass: KanjiBundleSearch.self)
    return bundle0
  }()
  
  private static let db: Connection? = {
    
    guard let podBundle = podBundle,
          let path = podBundle.pathForResource("kanjDB", ofType: "db") else { return nil }
    
    let db = try! Connection(path)
    return db
    
  }()
  
  public static func pathesForKanji(kanji: String) -> [Path]? {
    
    guard let db = db else { return nil }
    let kanjiTable =  Table("KANJI")
    let id = Expression<String>("id")
    let value = Expression<NSData>("VALUE")
    
    let query = kanjiTable.select(value).filter(id == kanji)
    guard let dbKanji = try! db.prepare(query).map({ $0 }).first else { return nil }
    let data = dbKanji[value]
    
    #if os(OSX)
    NSKeyedUnarchiver.setClass(NSBezierPath.self, forClassName: "UIBezierPath")
    #endif
    
    if let result = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Path] {
      return result
    }
    
    return nil
  }
  
}
