//
//  KanjiBezierPathesHelper.swift
//  Pods
//
//  Created by Andriy K. on 12/25/15.
//
//

import UIKit
import AWSQLiteDB

private class KanjiBundleSearch {}

public struct KanjiBezierPathesHelper {
  
  public static let podBundle: NSBundle? = {
    
    let bundle0 = NSBundle(forClass: KanjiBundleSearch.self)
    if let bundleURL = bundle0.URLForResource("KanjiBezierPaths", withExtension: "bundle") {
      if let bundle = NSBundle(URL: bundleURL) {
        return bundle
      }
      
    }
    return nil
  }()
  
  public static let db: SQLiteDB? = {
    
    guard let podBundle = podBundle else { return nil }
    let path = podBundle.pathForResource("kanjDB", ofType: "db")
    
    let db = SQLiteDB(path: path)
    return db
    
  }()
  
  public static func pathesForKanji(kanji: String) -> [UIBezierPath]? {
    
    guard let db = db else { return nil }
    
    let rows = db.query("SELECT * FROM KANJI WHERE ID == ?", parameters: kanji)
    if let row = rows.first, let data = row["VALUE"]?.value?.data {
      if let result = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [UIBezierPath] {//unarchiveObjectWithFile(path) as? [UIBezierPath] {
        return result
      }
    }
    
    return nil
  }
  
}
