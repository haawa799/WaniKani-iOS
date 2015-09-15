//
//  Extensions.swift
//  WaniKani
//
//  Created by Andriy K. on 9/15/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

public protocol Singltone: NSObjectProtocol {
  typealias T
  static func sharedInstance() -> T
}
