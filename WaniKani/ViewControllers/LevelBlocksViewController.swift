//
//  LevelBlocksViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 1/11/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

struct WaniLevelBlocks {
  
  let pleasant = LevelBlock(char: "快 ", name: "PLEASANT", hint: "[1-10]")
  let painful = LevelBlock(char: "苦 ", name: "PAINFUL", hint: "[11-20]")
  let death = LevelBlock(char: "死 ", name: "DEATH", hint: "[21-30]")
  let hell = LevelBlock(char: "地獄 ", name: "HELL", hint: "[31-40]")
  let paradise = LevelBlock(char: "天堂 ", name: "PARADISE", hint: "[41-50]")
  let reality = LevelBlock(char: "現実 ", name: "REALITY", hint: "[51-60]")
  
  var blocks: [LevelBlock] {
   return [pleasant, painful, death, hell, paradise, reality]
  }
}

struct LevelBlock {
  var char: String
  var name: String
  var hint: String
}

class LevelBlocksViewController: UIViewController {
  
  let waniLevelBlocks = WaniLevelBlocks().blocks
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      let cellNib = UINib(nibName: "LevelsBlockCell", bundle: nil)
      collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: LevelsBlockCell.identifier)
      collectionView?.dataSource = self
      collectionView?.delegate = self
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let vc = segue.destinationViewController as? LevelPickerViewController, let index = sender as? Int {
      vc.index = index
    }
  }
}

extension LevelBlocksViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return waniLevelBlocks.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LevelsBlockCell.identifier, forIndexPath: indexPath)
    
    if let levelsBlockCell = cell as? LevelsBlockCell {
      let block = waniLevelBlocks[indexPath.item]
      levelsBlockCell.setupWith(topText: block.char, botText: block.name, midText: block.hint)
    }
    
    return cell
  }
}

extension LevelBlocksViewController: UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("pickLevel", sender: indexPath.item)
  }
  
}