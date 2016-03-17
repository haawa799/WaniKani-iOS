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
      let progressHeaderNib = UINib(nibName: "ProgressHeader", bundle: nil)
      collectionView?.registerNib(progressHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ProgressHeader.identifier)
    }
  }
  
  @IBAction private func refresh() {
//    DataFetchManager.sharedInstance.fetchAllData()
  }
  
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
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Dashboard.rawValue)
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
    collectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
      // Add your logic here
      // Do not forget to call dg_stopLoading() at the end
      delay(4, closure: { () -> () in
        self?.collectionView.dg_stopLoading()
      })
//      self?.collectionView.dg_stopLoading()
      }, loadingView: loadingView)
    let patternColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)//UIColor(patternImage: UIImage(named: "pattern")!)
    collectionView.dg_setPullToRefreshFillColor(patternColor)
    collectionView.dg_setPullToRefreshBackgroundColor(collectionView.backgroundColor!)
    
    collectionView.contentInset.top += 70// = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    
    flipVisibleCells()
    collectionView.reloadData()
  }
  
  
  private var stratchyLayout: DashboardLayout {
    return collectionView.collectionViewLayout as! DashboardLayout
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let top = self.topLayoutGuide.length
    let bottom = self.bottomLayoutGuide.length
    let newInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    self.collectionView.contentInset = newInsets
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
    case 0: header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: ProgressHeader.identifier, forIndexPath: indexPath)
    default: header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath)
    }
    return header
  }
}
