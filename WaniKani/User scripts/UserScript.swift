//
//  UserScript.swift
//  
//
//  Created by Andriy K. on 9/9/15.
//
//

import UIKit

class UserScript: NSObject {
  
  class func scriptNamed(filename: String, name: String) -> UserScript? {
    let script = UserScript(filename: filename, scriptName: name)
    return script
  }
  
  private(set) var name: String
  
  init(filename: String, scriptName: String) {
    name = scriptName
    if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "js"), let js = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
      script = js
    } else {
      assertionFailure("Failed loading script with name: \(filename)")
    }
  }
  
  private(set) var script: String = ""
  
}
