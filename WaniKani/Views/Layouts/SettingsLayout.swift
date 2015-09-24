//
//  SettingsLayout.swift
//  WaniKani
//
//  Created by Andriy K. on 9/23/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class SettingsLayout: UICollectionViewFlowLayout {
  
  private let aspectRatio: CGFloat = 724 / 125
  private let defaultCellInset: CGFloat = 7
  let rowsSpacing: CGFloat = 1
  
  override func prepareLayout() {
    sectionInset = UIEdgeInsets(top: 0, left: defaultCellInset, bottom: defaultCellInset, right: defaultCellInset)
    
    let width = collectionViewContentSize().width - sectionInset.left - sectionInset.right
    let height = width / aspectRatio
    itemSize = CGSize(width: width, height: height)
    
    let headerHeight = height * 0.5
    headerReferenceSize = CGSize(width: width, height: headerHeight)
    
    if let collectionView = collectionView {
      let insets = collectionView.contentInset
      collectionView.contentInset = UIEdgeInsets(top: insets.top + height, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
    
    minimumLineSpacing = rowsSpacing
    sectionInset = UIEdgeInsets(top: 0, left: defaultCellInset, bottom: height * 0.5, right: defaultCellInset)
  }
  
}
