//
//  SingleTabViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 3/30/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class SingleTabViewController: UIViewController {
  
  var isTabBarShrinked: Bool = false
  
}

// MARK: - UIViewController
extension SingleTabViewController {
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let orientation = UIDevice.currentDevice().orientation.isLandscape
    let sizeClass = self.view.traitCollection.verticalSizeClass
    
    switch (isLandscape: orientation, sizeClass) {
    case (isLandscape: true, UIUserInterfaceSizeClass.Compact): shrink()
    default: unshrink()
    }
  }
  
  func didShrink() {
    
  }
  
  func didUnshrink() {
    
  }
  
}

// MARK: - Private
extension SingleTabViewController {
  
  private func shrink() -> Bool {
    guard isTabBarShrinked == false else { return false }
    hideTabBar(true)
    isTabBarShrinked = true
    didShrink()
    return true
  }
  
  private func unshrink() -> Bool {
    guard isTabBarShrinked == true else { return false }
    showTabBar(true)
    isTabBarShrinked = false
    didUnshrink()
    return true
  }
  
}