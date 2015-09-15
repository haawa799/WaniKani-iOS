//
//  UserScript.swift
//  
//
//  Created by Andriy K. on 9/9/15.
//
//

import UIKit

class UserScript: NSObject {
  
  class func scriptNamed(name: String) -> UserScript? {
    let script = UserScript(name: name)
    return script
  }
  
  init(name: String) {
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "js"), let js = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
      script = js
    } else {
      assertionFailure("Failed loading script with name: \(name)")
    }
  }
  
  private(set) var script: String = ""
  
}
