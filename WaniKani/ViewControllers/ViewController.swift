//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      let cellNib = UINib(nibName: "AvaliableItemCell", bundle: nil)
      collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: AvaliableItemCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
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
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AvaliableItemCell.identifier, forIndexPath: indexPath) as! AvaliableItemCell
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath) as! DashboardHeader
    header.titleLabel?.text = "Avaliable"
    return header
  }
}

