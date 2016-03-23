//✅
//  DashboardCoordinator.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

public class DashboardCoordinator: Coordinator, DashboardViewControllerDelegate {
  
  let presenter: UINavigationController
  private let dashboardViewController: DashboardViewController
  let childrenCoordinators: [Coordinator]
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    dashboardViewController = DashboardViewController.instantiateViewController()
    childrenCoordinators = []
  }
  
  func start() {
    fetchAllDashboardData()
    dashboardViewController.delegate = self
    presenter.pushViewController(dashboardViewController, animated: false)
  }
  
}

// MARK: - Dashboard data fetch
extension DashboardCoordinator {
  
  private func fetchDashboardData() {
    let sections = [
      // Section 0
      CollectionViewSection(nil, []),
      
      // Section 1
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Available") as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((AvaliableItemCellViewModel() as ViewModel), AvaliableItemCell.identifier),
        CollectionViewCellDataItem((AvaliableItemCellViewModel() as ViewModel), AvaliableItemCell.identifier)
        ]),
      
      // Section 2
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Reviews") as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((LeftRightTitleViewModel() as ViewModel), ReviewCell.identifier),
        CollectionViewCellDataItem((LeftRightTitleViewModel() as ViewModel), ReviewCell.identifier),
        CollectionViewCellDataItem((LeftRightTitleViewModel() as ViewModel), ReviewCell.identifier)
        ])
    ]
    dashboardViewController.collectionViewModel = CollectionViewViewModel(sections: sections)
  }
  
  private func fetchProgressionData() {
    let progressViewModel = DoubleProgressViewModel()
    let levelViewModel = DoubleProgressLevelModel()
    dashboardViewController.progressionData = (progressViewModel, levelViewModel)
  }
  
  private func fetchAllDashboardData() {
    fetchProgressionData()
    fetchDashboardData()
  }
}

// MARK: - DashboardViewControllerDelegate
extension DashboardCoordinator {
  
  func dashboardPullToRefreshAction() {
    fetchAllDashboardData()
  }
  
}
