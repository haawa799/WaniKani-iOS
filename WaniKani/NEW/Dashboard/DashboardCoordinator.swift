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
  
  let dataProvider = DataProvider()
  
  public init(presenter: UINavigationController) {
    self.presenter = presenter
    dashboardViewController = DashboardViewController.instantiateViewController()
    childrenCoordinators = []
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func start() {
    
    // New data notifications
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardCoordinator.newStudyQueue(_:)), name: DataProvider.NotificationName.NewStudyQueueReceivedNotification.rawValue, object: nil)
    
    // Fetch
    fetchAllDashboardData()
    dashboardViewController.delegate = self
    presenter.pushViewController(dashboardViewController, animated: false)
  }
  
}

// MARK: - Dashboard data fetch
extension DashboardCoordinator {
  
  private func fetchDashboardCollectionViewData() {
    dataProvider.fetchLastStoredStudyQ { (user, studyQueue) in
      self.updateDashboardCollectionView(studyQueue)
    }
    dataProvider.fetchNewStudyQ { (error) in
      fatalError()
    }
  }
  
  private func updateDashboardCollectionView(studyQueue: StudyQueue?) {
    guard let studyQueue = studyQueue else {
      self.dashboardViewController.endLoadingIfNeeded()
      return
    }
    let viewModel = CollectionViewViewModel.collectionViewModelWith(studyQueue: studyQueue)
    self.dashboardViewController.collectionViewModel = viewModel
  }
  
  private func fetchProgressionData() {
    let progressViewModel = DoubleProgressViewModel()
    let levelViewModel = DoubleProgressLevelModel()
    dashboardViewController.progressionData = (progressViewModel, levelViewModel)
  }
  
  private func fetchAllDashboardData() {
    fetchProgressionData()
    fetchDashboardCollectionViewData()
  }
}

// MARK: - DashboardViewControllerDelegate
extension DashboardCoordinator {
  
  func dashboardPullToRefreshAction() {
    fetchAllDashboardData()
  }
  
}

// MARK: - New data notifications
extension DashboardCoordinator {
  
  @objc func newStudyQueue(studyQueue: AnyObject) {
    guard let studyQueue = studyQueue as? StudyQueue else { return }
    updateDashboardCollectionView(studyQueue)
  }
  
}
