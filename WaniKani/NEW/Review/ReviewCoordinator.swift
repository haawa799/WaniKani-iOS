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

public class ReviewCoordinator: Coordinator, BottomBarContainerDelegate {
  
  let presenter: UINavigationController
  let reviewViewController: BottomBarContainerViewController
  let sideMenuController: ReviewViewController
  
  let childrenCoordinators: [Coordinator]
  
  let dataProvider = DataProvider()
  
  weak var delegate: ReviewCoordinatorDelegate?
  
  public init(presenter: UINavigationController, settingsSuit: SettingsSuit, type: WebSessionType) {
    self.presenter = presenter
    reviewViewController = BottomBarContainerViewController.instantiateViewController()
    sideMenuController = ReviewViewController(type: type, settingsSuit: settingsSuit)
    childrenCoordinators = []
  }
  
  func start() {
    reviewViewController.delegate = self
    presenter.presentViewController(reviewViewController, animated: true, completion: nil)
    reviewViewController.childViewController = sideMenuController
  }
  
}

public extension ReviewCoordinator {
  func leftButtonPressed() {
    presenter.dismissViewControllerAnimated(true) { 
      self.delegate?.reviewCompleted(self)
    }
  }
  
  func rightButtonPressed() {
    
  }
}

