//
//  ViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/27/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import StrokeDrawingView
import RealmSwift
import DataKit

class LevelViewController: UIViewController {
  
  var kanjiViewController: KanjiStrokesViewController?
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.delegate = self
    }
  }
  
  var level: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Data.rawValue)
    
    appDelegate.notificationCenterManager.addObserver(self, notification: .UpdatedKanjiListNotification, selector: "fetchNewDataFromRealm")
    DataFetchManager.sharedInstance.fetchLevelKanji(level)
    fetchNewDataFromRealm()
  }
  
  deinit {
    appDelegate.notificationCenterManager.removeObserver(self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let kanjiVC = segue.destinationViewController as? KanjiStrokesViewController {
      kanjiViewController = kanjiVC
    }
  }
  
  func fetchNewDataFromRealm() {
    if let levelData = user?.levels?.levelDataForLevel(level) {
      kanjiArray = levelData.kanjiList
    }
  }
  
  var kanjiArray: List<Kanji>? {
    didSet {
      collectionView.reloadData()
    }
  }
}

extension LevelViewController: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return kanjiArray?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("kanjiCell", forIndexPath: indexPath)
    
    if let kanji = kanjiArray?[indexPath.item], let kanjiCell = cell as? KanjiCell {
      print(kanji)
      kanjiCell.setupWithKanji(kanji)
    }
    
    return cell
  }
}

extension LevelViewController {
  
  func newData() {
    
  }
  
}

extension LevelViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if let kanji = kanjiArray?[indexPath.item] {
      kanjiViewController?.kanjiInfo = kanji
    }
  }
}



