//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift

class ViewController: UIViewController {
  
  var studyQueue: StudyQueue? = {
    let users = Realm().objects(User)
    if let user = users.first, let q = user.studyQueue {
      return q
    }
    return nil
    }()
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  var refreshControl: UIRefreshControl?
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.alwaysBounceVertical = true
      collectionView?.dataSource = self
      let cellNib = UINib(nibName: "AvaliableItemCell", bundle: nil)
      collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: AvaliableItemCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)

      let refresh = UIRefreshControl()
      refresh.tintColor = UIColor.grayColor()
      refresh.addTarget(self, action: "refershControlAction", forControlEvents: UIControlEvents.ValueChanged)
      refreshControl = refresh
      collectionView?.addSubview(refresh)
    }
  }
  
  @objc private func refershControlAction() {
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if blurView.alpha == 0 {
      UIView.animateWithDuration(1, animations: { () -> Void in
        self.blurView.alpha = 1
      })
    }
  }
  
  
}

extension ViewController : UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0: return 2
    case 1: return 3
    default: break
    }
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AvaliableItemCell.identifier, forIndexPath: indexPath) as! AvaliableItemCell
    
    if let q = studyQueue {
      switch (indexPath.section, indexPath.row) {
      case (0, 0): cell.setupWith("\(q.lessonsAvaliable) Lessons", enabled: (q.lessonsAvaliable > 0))
      case (0, 1): cell.setupWith("\(q.reviewsAvaliable) Reviews", enabled: (q.reviewsAvaliable > 0))
      case (1, 0): cell.setupWith("Next review \(q.nextReviewWaitingData().string)", enabled: (q.lessonsAvaliable > 0))
      case (1, 1): cell.setupWith("Next hour - \(q.reviewsNextHour)", enabled: false)
      case (1, 2): cell.setupWith("Next day - \(q.reviewsNextDay)", enabled: false)
      default: break
      }
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath) as! DashboardHeader
    switch indexPath.section {
    case 0: header.titleLabel?.text = "Avaliable"
    case 1: header.titleLabel?.text = "Reviews"
    default: break
    }
    return header
  }
}

extension ViewController {
  
  override func shouldAutorotate() -> Bool {
    return false
  }
  
}
