//
//  ScreenBackgoundTests.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
@testable import WaniKani

class ScreenBackgoundTests: XCTestCase {
  
  let realImageName = "setup_bg_blured"
  let fakeImageName = "fakeeee"
  
  var viewController: UIViewController!
}


// MARK: - Setup
extension ScreenBackgoundTests {
  
  override func setUp() {
    super.setUp()
    
    viewController = UIViewController()
  }
  
  override func tearDown() {
    super.tearDown()
    viewController = nil
  }
  
}

// MARK: - Tests
extension ScreenBackgoundTests {
  
  func testAvaliable() {
    let q = viewController as BluredBackground
    XCTAssertNotNil(q)
  }
  
  func testRealImage() {
    let result = viewController.addBackground(realImageName)
    XCTAssertEqual(result, true)
  }
  
  func testFakeImage() {
    let result = viewController.addBackground(fakeImageName)
    XCTAssertEqual(result, false)
  }
  
  func testImageViewAdded() {
    viewController.addBackground(realImageName)
    let imageView = viewController.view.subviews.first as! UIImageView
    XCTAssertEqual(imageView.translatesAutoresizingMaskIntoConstraints, false)
  }
  
  func testBackgroundOptions() {
    XCTAssertEqual(viewController.addBackground(BackgroundOptions.Data.rawValue), true)
    XCTAssertEqual(viewController.addBackground(BackgroundOptions.Dashboard.rawValue), true)
    XCTAssertEqual(viewController.addBackground(BackgroundOptions.Setup.rawValue), true)
  }
  
}
