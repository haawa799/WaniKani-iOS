//
//  ReviewCoordinator+SideMenu.swift
//  WaniKani
//
//  Created by Andriy K. on 4/10/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import RESideMenu

extension ReviewCoordinator: RESideMenuDelegate {
  
  @objc public func sideMenu(sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
    
  }
  
  @objc public func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
    hideBar()
  }
  
  @objc public func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
    
  }
  
  @objc public func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
    
  }
  
  @objc public func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
    showBar()
  }
  
}

