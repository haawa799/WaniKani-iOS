//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.alwaysBounceVertical = true
      collectionView?.dataSource = self
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
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
    var header: UICollectionReusableView
    switch indexPath.section {
    case 0: header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: ProgressHeader.identifier, forIndexPath: indexPath)
    default: header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath)
    }
    return header
  }
}
