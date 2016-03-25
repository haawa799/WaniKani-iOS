//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

protocol DashboardViewControllerDelegate: class {
  func dashboardPullToRefreshAction()
}

class DashboardViewController: UIViewController, StoryboardInstantiable, UICollectionViewDelegate {
  
  // MARK: Outlets
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var doubleProgressBar: DoubleProgressBar!
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.alwaysBounceVertical = true
      collectionView?.dataSource = self
      collectionView?.delegate = self
      let avaliableCellNib = UINib(nibName: AvaliableItemCell.nibName, bundle: nil)
      collectionView?.registerNib(avaliableCellNib, forCellWithReuseIdentifier: AvaliableItemCell.identifier)
      let reviewCellNib = UINib(nibName: ReviewCell.nibName, bundle: nil)
      collectionView?.registerNib(reviewCellNib, forCellWithReuseIdentifier: ReviewCell.identifier)
      let nextReviewCellNib = UINib(nibName: NextReviewCell.nibName, bundle: nil)
      collectionView?.registerNib(nextReviewCellNib, forCellWithReuseIdentifier: NextReviewCell.identifier)
      let headerNib = UINib(nibName: DashboardHeader.nibName, bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
  }
  
  // MARK: Public API
  weak var delegate: DashboardViewControllerDelegate?
  
  func freshCollectionViewModel(collectionViewModel: CollectionViewViewModel?, isOld: Bool = false) {
    self.collectionViewModel = collectionViewModel
    reloadCollectionView((isOld==false))
  }
  
  func freshLevelProgressionViewModel(viewModel: DoubleProgressViewModel?) {
    reloadProgressBarProgression(viewModel)
  }
  
  func freshUserLevelViewModel(viewModel: DoubleProgressLevelModel?) {
    reloadProgressBarUserLevel(viewModel)
  }
  
  func endLoadingIfNeeded() {
    if isPulledDown == true {
      isPulledDown = false
      collectionView.dg_stopLoading()
    }
  }
  
  // MARK: Private
  private var collectionViewModel: CollectionViewViewModel?
  private var isHeaderShrinked = false
  private var isPulledDown = false
  private var stratchyLayout: DashboardLayout {
    return collectionView.collectionViewLayout as! DashboardLayout
  }
  
}

// MARK: - UICollectionViewDataSource
extension DashboardViewController : UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    guard let collectionViewModel = collectionViewModel else { return 0 }
    return collectionViewModel.numberOfSections()
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewModel?.numberOfItemsInSection(section) ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    guard let item = collectionViewModel?.cellDataItemForIndexPath(indexPath) else { return cell }
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(item.reuseIdentifier, forIndexPath: indexPath)
    (cell as? ViewModelSetupable)?.setupWithViewModel(item.viewModel)
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let _ = collectionViewModel?.headerItem(section) else { return CGSizeZero }
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSizeZero }
    return flowLayout.headerReferenceSize
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    var header: UICollectionReusableView!
    guard let item = collectionViewModel?.headerItem(indexPath.section) else { return header }
    header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: item.reuseIdentifier, forIndexPath: indexPath)
    (header as? ViewModelSetupable)?.setupWithViewModel(item.viewModel)
    return header
  }
}

// MARK: - UIViewController
extension DashboardViewController {
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Dashboard.rawValue)
    
    addPullToRefresh()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let top = self.topLayoutGuide.length
    let bottom = self.bottomLayoutGuide.length
    let newInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    self.collectionView.contentInset = newInsets
    
    let orientation = UIDevice.currentDevice().orientation.isLandscape
    let sizeClass = self.view.traitCollection.verticalSizeClass
    
    switch (isLandscape: orientation, sizeClass) {
    case (isLandscape: true, UIUserInterfaceSizeClass.Compact): shrinkHeader()
    default: unshrinkHeader()
    }
  }
  
}

// MARK: - Private functions
extension DashboardViewController {
  
  private func addPullToRefresh() {
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
    collectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
      // Add your logic here
      self?.isPulledDown = true
      self?.delegate?.dashboardPullToRefreshAction()
      }, loadingView: loadingView)
    let fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
    collectionView.dg_setPullToRefreshFillColor(fillColor)
    collectionView.dg_setPullToRefreshBackgroundColor(UIColor.clearColor())
  }
  
  private func reloadCollectionView(flipCells: Bool) {
    endLoadingIfNeeded()
    if flipCells {
      flipVisibleCells()
    }
    collectionView?.reloadData()
  }
  
  private func reloadProgressBarProgression(viewModel: DoubleProgressViewModel?) {
    guard let viewModel = viewModel else { return }
    doubleProgressBar?.setupProgress(viewModel)
  }
  
  private func reloadProgressBarUserLevel(viewModel: DoubleProgressLevelModel?) {
    guard let viewModel = viewModel else { return }
    doubleProgressBar?.setupLevel(viewModel)
  }
  
  private func shrinkHeader() {
    guard isHeaderShrinked == false else { return }
    headerHeightConstraint.constant = 0
    isHeaderShrinked = true
    doubleProgressBar.hidden = true
    hideTabBar(true)
  }
  
  private func unshrinkHeader() {
    guard isHeaderShrinked == true else { return }
    headerHeightConstraint.constant = view.bounds.height * 0.15
    isHeaderShrinked = false
    doubleProgressBar.hidden = false
    showTabBar(true)
  }
  
  private func flipVisibleCells() {
    var delayFromFirst:Float = 0.0
    let deltaTime:Float = 0.1
    guard let cells = collectionView?.visibleCells() else { return }
    for cell in cells{
      delayFromFirst += deltaTime
      (cell as? FlippableView)?.flip(animations: {
        }, delay: NSTimeInterval(delayFromFirst))
    }
  }
  
}
