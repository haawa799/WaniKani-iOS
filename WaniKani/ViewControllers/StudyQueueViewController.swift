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

class StudyQueueViewController: UIViewController {
  
  private var loadedQueue: StudyQueue?
  var studyQueue: StudyQueue? {
    if loadedQueue == nil {
      let users = try! Realm().objects(User)
      if let user = users.first {
        if let q = user.studyQueue {
          loadedQueue = q
        }
      }
    }
    return loadedQueue
  }
  
  private var loadedProgressData: ProgressHeaderData?
  var progressData: ProgressHeaderData? {
    if loadedProgressData == nil {
      let users = try! Realm().objects(User)
      if let user = users.first, let progression = user.levelProgression {
        loadedProgressData = ProgressHeaderData(level: user.level, maxTopValue: progression.kanjiTotal, topValue: progression.kanjiProgress, maxBotValue: progression.radicalsTotal,botValue: progression.radicalsProgress)
      }
    }
    return loadedProgressData
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
      let nextReviewCellNib = UINib(nibName: "NextReviewCell", bundle: nil)
      collectionView?.registerNib(nextReviewCellNib, forCellWithReuseIdentifier: NextReviewCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
      let progressHeaderNib = UINib(nibName: "ProgressHeader", bundle: nil)
      collectionView?.registerNib(progressHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ProgressHeader.identifier)
    }
  }
  
  @IBAction private func refresh() {
    DataFetchManager.sharedInstance.fetchAllData()
  }
  
  func flipVisibleCells() {
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
    
    appDelegate.notificationCenterManager.addObserver(self, notification: .NoApiKeyNotification, selector: "noApiKeyNotification")
    appDelegate.notificationCenterManager.addObserver(self, notification: .NewStudyQueueReceivedNotification, selector: "newStudyQueueData")
    appDelegate.notificationCenterManager.addObserver(self, notification: .NewLevelProgressionReceivedNotification, selector: "newLevelProgressionData")
    
    collectionView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let vc = segue.destinationViewController as? WebViewController, let index = sender as? Int {
      switch index {
      case 0: vc.url = "https://www.wanikani.com/lesson/session"
      vc.type = .Lesson
      case 1:
        vc.url = "https://www.wanikani.com/review/session"
        vc.type = .Review
      default: break
      }
    }
  }
  
  deinit {
    appDelegate.notificationCenterManager.removeObserver(self)
  }
  
  var stratchyLayout: DashboardLayout {
    return collectionView.collectionViewLayout as! DashboardLayout
  }
  
  private var isPresented = false {
    didSet {
      if isPresented == true && needsToPresentAPIPrompt == true {
        needsToPresentAPIPrompt = false
        promptForAPIKey()
      }
    }
  }
  private var needsToPresentAPIPrompt = false
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if appDelegate.waniApiManager.apiKey() != nil {
      var token: dispatch_once_t = 0
      dispatch_once(&token) {
        AwardsManager.sharedInstance.authenticateLocalPlayer()
      }
    }
    
    isPresented = true
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    isPresented = false
  }
  
  private var lastUpdateDate: NSDate?
  private var waitingTime: NSTimeInterval = 20
  private var stratchyHeader: ProgressHeader?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    var needsUpdate = true
    
    if let lastUpdateDate = lastUpdateDate {
      let time = NSDate().timeIntervalSinceDate(lastUpdateDate)
      if time < waitingTime {
        needsUpdate = false
      }
    }
    
    if needsUpdate {
      if (UIApplication.sharedApplication().delegate as? AppDelegate)?.isBackgroundFetching == false {
        refresh()
      }
      lastUpdateDate = NSDate()
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
extension StudyQueueViewController {
  
  func noApiKeyNotification() {
    if isPresented == false {
      needsToPresentAPIPrompt = true
    } else {
      promptForAPIKey()
    }
  }
  
  private func promptForAPIKey() {
    performSegueWithIdentifier("apiKeyPicker", sender: nil)
  }
  
  func newStudyQueueData() {
    stratchyHeader?.displayLoading = false
    loadedQueue = nil
    dispatch_async(dispatch_get_main_queue(), {
      self.flipVisibleCells()
      self.collectionView.reloadData()
    })
  }
  
  func newLevelProgressionData() {
    loadedProgressData = nil
    guard let progressData = progressData else {return}
    stratchyHeader?.setupWithProgressionData(progressData)
  }
  
}

extension StudyQueueViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? AvaliableItemCell {
      if cell.enabled == true {
        if indexPath.section == 1 {
          performSegueWithIdentifier("browserSegue", sender: indexPath.row)
        }
      }
    }
  }
}

extension StudyQueueViewController : UICollectionViewDataSource {
  
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
    
    if let q = studyQueue {
      switch (indexPath.section, indexPath.row) {
      case (1, 0): (cell as? AvaliableItemCell)?.setupWith("\(q.lessonsAvaliable) Lessons", enabled: (q.lessonsAvaliable > 0))
      case (1, 1): (cell as? AvaliableItemCell)?.setupWith("\(q.reviewsAvaliable) Reviews", enabled: (q.reviewsAvaliable > 0))
      case (2, 0):
        if let c = cell as? NextReviewCell {
          c.setupWith("Next review \(q.nextReviewWaitingData().string)", notifications: NotificationManager.sharedInstance.notificationsEnabled)
          c.delegate = self
        }
      case (2, 1): (cell as? ReviewCell)?.setupWith("Next hour", numberText: "\(q.reviewsNextHour)")
      case (2, 2): (cell as? ReviewCell)?.setupWith("Next day", numberText: "\(q.reviewsNextDay)")
      default: break
      }
    }
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
    //ProgressHeader
    switch indexPath.section {
    case 0:
      stratchyHeader = (header as? ProgressHeader)
      stratchyHeader?.progressHeaderDelegate = self
      if let progressData = progressData {
        stratchyHeader?.setupWithProgressionData(progressData)
      }
    case 1: (header as? DashboardHeader)?.titleLabel?.text = "Available"
    case 2: (header as? DashboardHeader)?.titleLabel?.text = "Reviews"
    default: break
    }
    return header
  }
}

extension StudyQueueViewController: NextReviewCellDelegate {
  func notificationsEnabled(enabled: Bool) {
    NotificationManager.sharedInstance.notificationsEnabled = enabled
  }
}

extension StudyQueueViewController: ProgressHeaderDelegate {
  func fullStretch() {
    refresh()
    stratchyHeader?.displayLoading = true
  }
}
