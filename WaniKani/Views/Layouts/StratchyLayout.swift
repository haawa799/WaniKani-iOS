//
//  StratchyLayout.swift
//  WaniKani
//
//  Created by Andriy K. on 9/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class StratchyLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var deltaY: CGFloat = 0
  var maxDelta: CGFloat = CGFloat.max
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! StratchyLayoutAttributes
    copy.deltaY = deltaY
    return copy
  }
  
  override func isEqual(object: AnyObject?) -> Bool {
    if let attributes = object as? StratchyLayoutAttributes {
      if attributes.deltaY == deltaY {
        return super.isEqual(object)
      }
    }
    return false
  }
}

class StratchyHeaderLayout: UICollectionViewFlowLayout {
  
  var stratchyHeaderSize = CGSizeZero
  var maxDelta: CGFloat {
    return stratchyHeaderSize.height * 1.5
  }
  
  
  override class func layoutAttributesClass() -> AnyClass {
    return StratchyLayoutAttributes.self
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    let insets = collectionView!.contentInset
    let offset = collectionView!.contentOffset
    let minY = -insets.top
    
    
    let attributes = super.layoutAttributesForElementsInRect(rect)
    
    if let stratchyAttributes = attributes as? [StratchyLayoutAttributes] {
      // Check if we've pulled below past the lowest position
      if (offset.y < minY){
        let deltaY = fabs(offset.y - minY)
        
        for attribute in stratchyAttributes{
          if (attribute.indexPath.section == 0){
            if let kind = attribute.representedElementKind{
              if (kind == UICollectionElementKindSectionHeader) {
                var headerRect = attribute.frame
                headerRect.size.height =  min(stratchyHeaderSize.height + maxDelta, max(minY, stratchyHeaderSize.height + deltaY));
                headerRect.origin.y = CGRectGetMinY(headerRect) - deltaY;
                attribute.frame = headerRect
                attribute.deltaY = deltaY
                attribute.maxDelta = maxDelta
              }
            }
          }
        }
      }
    }
    
    return attributes
  }
}
