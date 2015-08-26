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
import KINWebBrowser

class ViewController: UIViewController {
  
  private var loadedQueue: StudyQueue?
  var studyQueue: StudyQueue? {
    if loadedQueue == nil {
      let users = Realm().objects(User)
      if let user = users.first, let q = user.studyQueue {
        loadedQueue = q
      }
    }
    return loadedQueue
  }
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  var refreshControl: UIRefreshControl?
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.alwaysBounceVertical = true
      collectionView?.dataSource = self
      collectionView?.delegate = self
      let avaliableCellNib = UINib(nibName: "AvaliableItemCell", bundle: nil)
      collectionView?.registerNib(avaliableCellNib, forCellWithReuseIdentifier: AvaliableItemCell.identifier)
      let reviewCellNib = UINib(nibName: "ReviewCell", bundle: nil)
      collectionView?.registerNib(reviewCellNib, forCellWithReuseIdentifier: ReviewCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
  }
  
  @IBAction private func refresh() {
    DataFetchManager.sharedInstance.fetchStudyQueue()
  }
  
  func flipVisibleCells() {
    var delayFromFirst:Float = 0.0
    var deltaTime:Float = 0.1
    
    var cells = self.collectionView.visibleCells()
    
    for cell in cells{
      if let cell = cell as? UICollectionViewCell {
        if let indexPath = self.collectionView.indexPathForCell(cell){
          delayFromFirst += deltaTime
          
          (cell as? FlippableCell)?.flip(animations: {
            }, delay: NSTimeInterval(delayFromFirst))
        }
      }
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "noApiKeyNotification", name: WaniApiManager.noApiKeyNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "newStudyQueueData", name: DataFetchManager.newStudyQueueReceivedNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if blurView.alpha == 0 {
//      collectionView.alpha = 0
      UIView.animateWithDuration(1, animations: { () -> Void in
        self.blurView.alpha = 1
//        self.collectionView.alpha = 1
      })
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let top = self.topLayoutGuide.length
    let bottom = self.bottomLayoutGuide.length
    let newInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    self.collectionView.contentInset = newInsets
  }
}

// Notifications
extension ViewController {
  
  func noApiKeyNotification() {
    performSegueWithIdentifier("apiKeyPicker", sender: nil)
  }
  
  func newStudyQueueData() {
    loadedQueue = nil
    flipVisibleCells()
    collectionView.reloadData()
  }
  
}

extension ViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? AvaliableItemCell {
      if cell.enabled == true {
        let webBrowser = KINWebBrowserViewController.webBrowser()
        webBrowser.actionButtonHidden = true
        webBrowser.showsPageTitleInNavigationBar = true
        webBrowser.tintColor = navigationController?.navigationBar.tintColor
        hidesBottomBarWhenPushed = true
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.pushViewController(webBrowser, animated: true)
        
        var url = ""
        switch (indexPath.section, indexPath.row) {
        case (0, 0): url = "https://www.wanikani.com/lesson/session"
        case (0, 1): url = "https://www.wanikani.com/review/session"
        default: break
        }
        
        webBrowser.loadURLString(url)
      }
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
    
    var cell: UICollectionViewCell
    var identifier: String = ""
    switch indexPath.section {
    case 0: identifier = AvaliableItemCell.identifier
    case 1: identifier = ReviewCell.identifier
    default: break
    }
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! UICollectionViewCell
    
    if let q = studyQueue {
      switch (indexPath.section, indexPath.row) {
      case (0, 0): (cell as? AvaliableItemCell)?.setupWith("\(q.lessonsAvaliable) Lessons", enabled: (q.lessonsAvaliable > 0))
      case (0, 1): (cell as? AvaliableItemCell)?.setupWith("\(q.reviewsAvaliable) Reviews", enabled: (q.reviewsAvaliable > 0))
      case (1, 0): (cell as? AvaliableItemCell)?.setupWith("Next review \(q.nextReviewWaitingData().string)", enabled: (q.lessonsAvaliable > 0))
      case (1, 1): (cell as? ReviewCell)?.setupWith("Next hour", numberText: "\(q.reviewsNextHour)")
      case (1, 2): (cell as? ReviewCell)?.setupWith("Next day", numberText: "\(q.reviewsNextDay)")
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
