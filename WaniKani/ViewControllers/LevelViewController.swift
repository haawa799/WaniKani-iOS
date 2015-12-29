//
//  ViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/27/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import StrokeDrawingView
import WaniKit

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
    
    let manager = WaniApiManager()
    manager.setApiKey("c6ce4072cf1bd37b407f2c86d69137e3")

    
    manager.fetchKanjiList(level) { (result) -> Void in
      switch result {
      case .Error(let error) : print(error())
      case .Response(let response) :
        let resp = response()
        
        self.kanjiArray = resp.kanji
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.collectionView!.reloadData()
        })
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let kanjiVC = segue.destinationViewController as? KanjiStrokesViewController {
      kanjiViewController = kanjiVC
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    showTabBar(true)
  }
  
  var kanjiArray: [KanjiInfo]?
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
      kanjiCell.setupWithKanji(kanji)
    }
    
    return cell
  }
}

extension LevelViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if let kanji = kanjiArray?[indexPath.item] {
      kanjiViewController?.kanjiInfo = kanji
    }
  }
}



