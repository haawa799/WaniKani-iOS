//
//  Q.swift
//  WaniKani
//
//  Created by Andriy K. on 3/25/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

// MARK: - Dashboard data fetch
public extension DashboardCoordinator {
  
  // MARK: All
  public func fetchAllDashboardData() {
    fetchProgressionData()
    fetchDashboardCollectionViewData()
  }
  
  private func fetchAllProgressionData() {
    dataProvider.fetchLastStoredProgression { (user, progression) in
      self.updateDashboardUserLevel(user)
      self.updateDashboardProgression(progression)
    }
    dataProvider.fetchNewProgression { (error) in
      fatalError()
    }
  }
  
  // MARK: Study Queue
  private func fetchDashboardCollectionViewData() {
    dataProvider.fetchLastStoredStudyQ { (user, studyQueue) in
      self.updateDashboardCollectionView(studyQueue, isOld: true)
    }
    dataProvider.fetchNewStudyQ { (error) in
      fatalError()
    }
  }
  
  private func updateDashboardCollectionView(studyQueue: StudyQueue?, isOld: Bool = false) {
    guard let studyQueue = studyQueue else {
      self.dashboardViewController.endLoadingIfNeeded()
      return
    }
    canOpenReview = studyQueue.reviewsAvaliable > 0
    canOpenLessons = studyQueue.lessonsAvaliable > 0
    
    let viewModel = CollectionViewViewModel.collectionViewModelWith(studyQueue: studyQueue)
    self.dashboardViewController.freshCollectionViewModel(viewModel, isOld: isOld)
  }
  
  
  // MARK: Level progression
  private func fetchProgressionData() {
    fetchAllProgressionData()
    dataProvider.fetchNewProgression { (error) in
      fatalError()
    }
  }
  
  private func updateDashboardProgression(levelProgression: LevelProgression?) {
    guard let levelProgression = levelProgression else { return }
    let progressViewModel = DoubleProgressViewModel(progression: levelProgression)
    dashboardViewController.freshLevelProgressionViewModel(progressViewModel)
  }
  
  // MARK: User level
  
  private func updateDashboardUserLevel(usr: User?) {
    guard let usr = usr else { return }
    let levelViewModel = DoubleProgressLevelModel(user: usr)
    dashboardViewController.freshUserLevelViewModel(levelViewModel)
  }
}

// MARL: - Notification registration
public extension DashboardCoordinator {
  
  public func registerForDataNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardCoordinator.newStudyQueue(_:)), name: DataProvider.NotificationName.NewStudyQueueReceivedNotification.rawValue, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardCoordinator.newLevelProgression(_:)), name: DataProvider.NotificationName.NewLevelProgressionReceivedNotification.rawValue, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DashboardCoordinator.newUserLevel(_:)), name: DataProvider.NotificationName.NewUserInfoReceivedNotification.rawValue, object: nil)
  }
  
  public func unregisterFromDataNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

// MARK: - New data notifications
extension DashboardCoordinator {
  
  @objc func newStudyQueue(notification: NSNotification) {
    guard let studyQueue = notification.object as? StudyQueue else { return }
    updateDashboardCollectionView(studyQueue)
  }
  
  @objc func newLevelProgression(notification: NSNotification) {
    guard let levelProgression = notification.object as? LevelProgression else { return }
    updateDashboardProgression(levelProgression)
  }
  
  @objc func newUserLevel(notification: NSNotification) {
    guard let user = notification.object as? User else { return }
    updateDashboardUserLevel(user)
  }
}
