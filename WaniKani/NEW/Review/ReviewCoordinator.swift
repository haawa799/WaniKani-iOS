//
//  ReviewCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 4/1/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public protocol ReviewCoordinatorDelegate: class {
  func reviewCompleted(coordinator: ReviewCoordinator)
}

public class ReviewCoordinator: NSObject, Coordinator, BottomBarContainerDelegate {
  
  let presenter: UINavigationController
  let containerViewController: BottomBarContainerViewController
  let sideMenuController: ReviewViewController
  
  let childrenCoordinators: [Coordinator]
  
  let dataProvider = DataProvider()
  
  private var sideMenuVisible = false
  
  weak var delegate: ReviewCoordinatorDelegate?
  
  public init(presenter: UINavigationController, settingsSuit: SettingsSuit, type: WebSessionType) {
    self.presenter = presenter
    containerViewController = BottomBarContainerViewController.instantiateViewController()
    sideMenuController = ReviewViewController(type: type, settingsSuit: settingsSuit)
    childrenCoordinators = []
  }
  
  func start() {
    containerViewController.delegate = self
    sideMenuController.delegate = self
    presenter.presentViewController(containerViewController, animated: true, completion: nil)
    containerViewController.childViewController = sideMenuController
  }
  
}

public extension ReviewCoordinator {
  func leftButtonPressed() {
    presenter.dismissViewControllerAnimated(true) { 
      self.delegate?.reviewCompleted(self)
    }
  }
  
  func rightButtonPressed() {
    if sideMenuVisible == true {
      sideMenuController.hideMenuViewController()
      sideMenuVisible = false
      showBar()
    } else {
      sideMenuController.presentRightMenuViewController()
      sideMenuVisible = true
      hideBar()
    }
    
  }
}

public extension ReviewCoordinator {
  
  func hideBar() {
    containerViewController.hideBar()
  }
  
  func showBar() {
    containerViewController.showBar()
  }
  
}

