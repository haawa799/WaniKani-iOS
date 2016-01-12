//
//  LevelsLayout.swift
//  WaniKani
//
//  Created by Andriy K. on 1/12/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class LevelsLayout: UICollectionViewFlowLayout {
  
  private let horizontalCellInset: CGFloat = 15
  private let verticalCellInset: CGFloat = 10
  
  override func prepareLayout() {
    
    guard let collectionView = collectionView else { return }
    
    sectionInset = UIEdgeInsets(top: verticalCellInset, left: horizontalCellInset, bottom: verticalCellInset, right: horizontalCellInset)
    
    let width = (collectionView.bounds.width * 0.5) - (1.5 * horizontalCellInset)
    let height = (collectionView.bounds.height - (2 * verticalCellInset) - (4 * verticalCellInset)) / 5
    
    itemSize = CGSize(width: width, height: height)
    
    minimumInteritemSpacing = verticalCellInset
    minimumLineSpacing = verticalCellInset
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
