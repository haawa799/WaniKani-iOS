//
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class DashboardCoordinator: Coordinator {
  
  let presenter: UINavigationController
  private let dashboardViewController: DashboardViewController
  
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
    
    dashboardViewController = DashboardViewController.instantiateViewController()
  }
  
  func start() {
    presenter.pushViewController(dashboardViewController, animated: false)
  }
}
