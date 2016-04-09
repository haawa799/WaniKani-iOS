//
//  SettingsLayout.swift
//  WaniKani
//
//  Created by Andriy K. on 9/23/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class SettingsLayout: UICollectionViewFlowLayout {
  
  let defaultCellInset: CGFloat = 9
  let rowsSpacing: CGFloat = 1
  let aspectRatio: CGFloat = 320/50
  let minSpacing: CGFloat = 20
  
  let maxHeight: CGFloat = 75
  
  var originalBotIset: CGFloat?
  
  
  override func prepareLayout() {
    
    guard let collectionView = collectionView else { return }
    let insets = collectionView.contentInset
    
    if originalBotIset == nil {
      originalBotIset = collectionView.contentInset.bottom
    }
    
    let contentSize = CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - originalBotIset!)
    collectionView.contentSize = contentSize
    
    var width = contentSize.width - (2 * defaultCellInset)
    let height = min(width / aspectRatio, maxHeight)
    width = height * aspectRatio
    let q = (contentSize.width - width - insets.left - insets.right) * 0.5
    let leftInset = max(q, defaultCellInset)
    let rightInset = leftInset
    
    let headerHeight = height * 0.5
    
    
    let numberOfSections: CGFloat = 2
    let numberOfCells: CGFloat = 5
    var usedHeight = headerHeight * (numberOfSections - 1)
    usedHeight += numberOfCells * height * numberOfCells
    
    let freeSpace = contentSize.height - usedHeight
    let freeSpacePerSection = max(freeSpace / CGFloat(numberOfSections), 0.7 * height)
    
    headerReferenceSize = CGSize(width: width, height: headerHeight)
    itemSize = CGSize(width: width, height: height)
    
    sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: freeSpacePerSection, right: rightInset)
    minimumInteritemSpacing = defaultCellInset
    minimumLineSpacing = rowsSpacing
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: freeSpacePerSection, right: 0)
    
    super.prepareLayout()
  }
  
}
