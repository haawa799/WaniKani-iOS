//
//  DashboardLayout.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

class DashboardLayout: UICollectionViewFlowLayout {
  
  let defaultCellInset: CGFloat = 7
  let rowsSpacing: CGFloat = 1
  let aspectRatio:CGFloat = 320/50
  let maxHeight: CGFloat = 60
  
  
  override func collectionViewContentSize() -> CGSize {
    let contentSize = super.collectionViewContentSize()
    
    sectionInset = UIEdgeInsets(top: defaultCellInset, left: defaultCellInset, bottom: 50, right: defaultCellInset)
    minimumInteritemSpacing = defaultCellInset
    minimumLineSpacing = rowsSpacing
    
    let width = contentSize.width - (sectionInset.left + sectionInset.right)
    let height = min(width / aspectRatio, maxHeight)
    
    itemSize = CGSize(width: width, height: height)
    headerReferenceSize = CGSize(width: width, height: height * 0.5)
    
    return contentSize
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
