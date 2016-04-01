//
//  ReviewCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 4/1/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public protocol ReviewCoordinatorDelegate: class {
  func reviewCompleted()
}

public class ReviewCoordinator: Coordinator {
  
  let presenter: UINavigationController
  let reviewViewController: ReviewViewController
  let childrenCoordinators: [Coordinator]
  
  let dataProvider = DataProvider()
  
  weak var delegate: ReviewCoordinatorDelegate?
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    reviewViewController = DashboardViewController.instantiateViewController()
    childrenCoordinators = []
  }
  
  func start() {
    presenter.presentViewController(reviewViewController, animated: true, completion: nil)
  }
  
}

