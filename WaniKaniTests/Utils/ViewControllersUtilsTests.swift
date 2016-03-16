//
//  ViewControllersUtilsTests.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKani

let testBundle = NSBundle(forClass: ViewControllerWithStoryboard.self)

class ViewControllersUtilsTests: XCTestCase {
  var viewController: ViewControllerWithStoryboard!
}

// MARK: - Setup
extension ViewControllersUtilsTests {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    viewController = nil
  }
  
}

// MARK: - Tests
extension ViewControllersUtilsTests {
  
  func testCanCreateFromStoryboard() {
    viewController = ViewControllerWithStoryboard.instantiateViewController(testBundle)
    XCTAssertNotNil(viewController)
  }
  
}
