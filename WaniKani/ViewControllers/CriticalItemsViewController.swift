//
//  CriticalItemsViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 11/5/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift

public class CriticalItemsViewController: UIViewController {
  
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.delegate = self
      collectionView?.alwaysBounceVertical = true
      let vocabCell = UINib(nibName: "WordCell", bundle: nil)
      collectionView?.registerNib(vocabCell, forCellWithReuseIdentifier: WordCell.identifier)
    }
  }
  
  
  private var loadedCriticalItems: [CriticalItem]?
  var criticalItems: [CriticalItem]? {
    if loadedCriticalItems == nil {
      let users = try! Realm().objects(User)
      if let user = users.first {
        if let q = user.criticalItems {
          loadedCriticalItems = q.plainListSortedByPercentage().filter(){return $0.type == ReviewItemType.Vocabulary}
          self.collectionView.reloadData()
        }
      }
    }
    return loadedCriticalItems
  }
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "criticalItemsReceived", name: DataFetchManager.newLevelProgressionReceivedNotification, object: nil)
    
    collectionView.reloadData()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func criticalItemsReceived() {
    loadedCriticalItems = nil
    collectionView.reloadData()
  }
  
}

extension CriticalItemsViewController: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return criticalItems?.count ?? 0
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let item = criticalItems![indexPath.row].item as! VocabItem
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WordCell.identifier, forIndexPath: indexPath) as! WordCell
    
    cell.setupWith(item.character, meaning: item.meaning, kana: item.kana, rightLabelText: "\(item.percentage)%")
    
    return cell
  }
}

extension CriticalItemsViewController: UICollectionViewDelegate {
  
}
