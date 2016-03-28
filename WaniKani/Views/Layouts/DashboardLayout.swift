//
//  DashboardLayout.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

class DashboardLayout: UICollectionViewFlowLayout {
  
  let defaultCellInset: CGFloat = 9
  let rowsSpacing: CGFloat = 1
  let aspectRatio: CGFloat = 320/50
  let minSpacing: CGFloat = 20
  
  let maxHeight: CGFloat = 75
  
  var originalBotIset: CGFloat?
  
  
  override func prepareLayout() {
    
    guard let collectionView = collectionView else { return }
    guard let datasource = collectionView.dataSource else { return }
    let insets = collectionView.contentInset
    
    if originalBotIset == nil {
      originalBotIset = collectionView.contentInset.bottom
    }
    
    let contentSize = CGSize(width: collectionView.bounds.size.width, height: /*maxSide*/collectionView.bounds.size.height - originalBotIset!)
    collectionView.contentSize = contentSize
    
    var width = contentSize.width - (2 * defaultCellInset)
    let height = min(width / aspectRatio, maxHeight)
    width = height * aspectRatio
    let q = (contentSize.width - width - insets.left - insets.right) * 0.5
    let leftInset = max(q, defaultCellInset)
    let rightInset = leftInset
    
    let headerHeight = height * 0.5
    
    guard let numberOfSections = datasource.numberOfSectionsInCollectionView?(collectionView) else { return }
    var usedHeight = headerHeight * CGFloat(numberOfSections - 1)
    for i in 0...numberOfSections {
      if let numberOfCells = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: i) {
        usedHeight += height * CGFloat(numberOfCells)
      }
    }
    
    let freeSpace = contentSize.height - usedHeight
    let freeSpacePerSection = max(freeSpace / CGFloat(numberOfSections), 0.5 * height)
    
    headerReferenceSize = CGSize(width: width, height: headerHeight)
    itemSize = CGSize(width: width, height: height)
    
    sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: freeSpacePerSection, right: rightInset)
    minimumInteritemSpacing = defaultCellInset
    minimumLineSpacing = rowsSpacing
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insets.bottom, right: 0)
    
    super.prepareLayout()
  }
  
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return false
  }
  
}
