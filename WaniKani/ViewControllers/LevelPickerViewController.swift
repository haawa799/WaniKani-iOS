//
//  LevelPickerViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class LevelPickerViewController: UIViewController {
  
  let numberOfLevels = 10
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.delegate = self
      let nib = UINib(nibName: "LevelCell", bundle: nil)
      collectionView?.registerNib(nib, forCellWithReuseIdentifier: LevelCell.identifier)
    }
  }
  
  var index = 0 {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  func levelForIndexPath(indexPath: NSIndexPath) -> Int {
    return (index * numberOfLevels) + indexPath.row
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let level = sender as? Int, let vc = segue.destinationViewController as? LevelViewController {
      
      let trueLevel = level + 1
      vc.title = "lvl: \(trueLevel)"
      vc.level = trueLevel
      
      vc.hidesBottomBarWhenPushed = true
    }
  }
}

extension LevelPickerViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfLevels
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LevelCell.identifier, forIndexPath: indexPath)
    
    if let levelCell = cell as? LevelCell {
      let level = levelForIndexPath(indexPath)
      levelCell.levelLabel.text = "Lvl:  \(level + 1)"
    }

    return cell
  }
  
}

extension LevelPickerViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("levelSelected", sender: levelForIndexPath(indexPath))
  }
}
