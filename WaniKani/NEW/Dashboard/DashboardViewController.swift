//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class DashboardViewController: UIViewController, StoryboardInstantiable, UICollectionViewDelegate {
  
  var progressViewModel: DoubleProgressViewModel?
  var levelViewModel: DoubleProgressLevelModel?
  
  private var isHeaderShrinked = false
  
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.alwaysBounceVertical = true
      collectionView?.dataSource = self
      collectionView?.delegate = self
      let avaliableCellNib = UINib(nibName: "AvaliableItemCell", bundle: nil)
      collectionView?.registerNib(avaliableCellNib, forCellWithReuseIdentifier: AvaliableItemCell.identifier)
      let reviewCellNib = UINib(nibName: "ReviewCell", bundle: nil)
      collectionView?.registerNib(reviewCellNib, forCellWithReuseIdentifier: ReviewCell.identifier)
      let nextReviewCellNib = UINib(nibName: "NextReviewCell", bundle: nil)
      collectionView?.registerNib(nextReviewCellNib, forCellWithReuseIdentifier: NextReviewCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
  }
  
  @IBOutlet weak var doubleProgressBar: DoubleProgressBar!
  
  
  private func flipVisibleCells() {
    var delayFromFirst:Float = 0.0
    let deltaTime:Float = 0.1
    
    let cells = self.collectionView.visibleCells()
    
    for cell in cells{
      delayFromFirst += deltaTime
      (cell as? FlippableView)?.flip(animations: {
        }, delay: NSTimeInterval(delayFromFirst))
    }
  }
  
  func addPullToRefresh() {
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
    collectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
      // Add your logic here
      self?.fetchNewData()
      }, loadingView: loadingView)
    let fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
    collectionView.dg_setPullToRefreshFillColor(fillColor)
    collectionView.dg_setPullToRefreshBackgroundColor(UIColor.clearColor())
  }
  
  func fetchNewData() {
    delay(2, closure: { () -> () in
      self.reloadAllData()
      self.collectionView.dg_stopLoading()
    })
  }
  
  func reloadAllData() {
    progressViewModel = DoubleProgressViewModel()
    levelViewModel = DoubleProgressLevelModel()
    
    doubleProgressBar.setupProgress(progressViewModel)
    doubleProgressBar.setupLevel(levelViewModel)
  }
  
  
  private var stratchyLayout: DashboardLayout {
    return collectionView.collectionViewLayout as! DashboardLayout
  }
  
}

extension DashboardViewController : UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 3
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0: return 0
    case 1: return 2
    case 2: return 3
    default: break
    }
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    var cell: UICollectionViewCell
    var identifier: String = ""
    switch (indexPath.section, indexPath.row) {
    case (2, 0): identifier = NextReviewCell.identifier
    case (1, _): identifier = AvaliableItemCell.identifier
    case (2, _): identifier = ReviewCell.identifier
    default: break
    }
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    switch section {
    case 0:
      if let stratchyLayout = collectionViewLayout as? StratchyHeaderLayout {
        return stratchyLayout.stratchyHeaderSize
      }
      return CGSizeZero
    default :
      if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
        return flowLayout.headerReferenceSize
      }
      return CGSizeZero
    }
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
    var header: UICollectionReusableView
    switch indexPath.section {
    default: header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath)
    }
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
    
    flipVisibleCells()
    collectionView.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let top = self.topLayoutGuide.length
    let bottom = self.bottomLayoutGuide.length
    let newInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    self.collectionView.contentInset = newInsets
    
    let orientation = UIDevice.currentDevice().orientation.isLandscape
    let sizeClass = self.view.traitCollection.verticalSizeClass
    
    print("isLanscape \(orientation)")
    print("compact \(sizeClass == .Compact)")
    
    switch (isLandscape: orientation, sizeClass) {
    case (isLandscape: true, UIUserInterfaceSizeClass.Compact): shrinkHeader()
    default: unshrinkHeader()
    }
  }
  
}

extension DashboardViewController {
  
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
  
}
