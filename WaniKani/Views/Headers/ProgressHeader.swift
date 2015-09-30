//
//  ProgressHeader.swift
//  WaniKani
//
//  Created by Andriy K. on 9/29/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

struct ProgressHeaderData {
  let topProgress: CGFloat
  let botProgress: CGFloat
}

protocol ProgressHeaderDelegate: class {
  func fullStretch()
}

class ProgressHeader: UICollectionReusableView, SingleReuseIdentifier {

  weak var progressHeaderDelegate: ProgressHeaderDelegate?
  
  @IBOutlet private weak var doubleProgressBar: DoubleProgressBar!
  @IBOutlet weak var bottomSpaceView: UIView!
  
  var bottomSpaceHeight: CGFloat = 0 {
    didSet {
      if oldValue == 0 && bottomSpaceHeight > 0.2 {
        progressHeaderDelegate?.fullStretch()
      }
    }
  }
  
  var levelInfoView: LevelInfoView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    levelInfoView = NSBundle.mainBundle().loadNibNamed("LevelInfoView", owner: self, options: nil).first as? LevelInfoView
    if let levelInfoView = levelInfoView {
      levelInfoView.frame = doubleProgressBar.circleContentView.bounds
      doubleProgressBar.circleContentView.addSubview(levelInfoView)
    }
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    super.applyLayoutAttributes(layoutAttributes)
    bottomSpaceHeight = bottomSpaceView.bounds.height
  }
  
  
}
