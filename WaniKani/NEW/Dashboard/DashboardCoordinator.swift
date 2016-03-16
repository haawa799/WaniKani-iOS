//
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class DashboardCoordinator: Coordinator {
  
  let presenter: UINavigationController
  private let dashboardViewController: DashboardViewController
  let childrenCoordinators: [Coordinator]
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    dashboardViewController = DashboardViewController.instantiateViewController()
    childrenCoordinators = []
  }
  
  func start() {
    presenter.pushViewController(dashboardViewController, animated: false)
  }
}
