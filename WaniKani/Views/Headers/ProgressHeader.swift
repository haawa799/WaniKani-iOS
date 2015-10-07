//
//  ProgressHeader.swift
//  WaniKani
//
//  Created by Andriy K. on 9/29/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit

protocol ProgressHeaderDelegate: class {
  func fullStretch()
}

struct ProgressHeaderData {
  let level: Int
  let maxTopValue: Int
  let topValue: Int
  let maxBotValue: Int
  let botValue: Int
}

class ProgressHeader: UICollectionReusableView, SingleReuseIdentifier {

  weak var progressHeaderDelegate: ProgressHeaderDelegate?
  
  @IBOutlet weak var lebelsContainer: UIView!
  @IBOutlet private weak var doubleProgressBar: DoubleProgressBar!
  @IBOutlet weak var bottomSpaceView: UIView!
  
  var displayLoading: Bool = false {
    didSet {
      if displayLoading != oldValue {
        activityIndicator?.hidden = false
        pullLabel?.hidden = false
        if displayLoading {
          UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.pullLabel?.alpha = 0
            self.activityIndicator?.alpha = 1
            }, completion: { (success) -> Void in
              self.pullLabel?.hidden = true
          })
        } else {
          UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.pullLabel?.alpha = 1
            self.activityIndicator?.alpha = 0
            }, completion: { (success) -> Void in
              self.activityIndicator?.hidden = true
          })
        }
      }
    }
  }
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var pullLabel: UILabel!
  
  @IBOutlet weak var botLabel: UILabel!
  @IBOutlet weak var topLabel: UILabel!
  
  var bottomSpaceHeight: CGFloat = 0 {
    didSet {
      if oldValue == 0 && bottomSpaceHeight > 0.2 {
        progressHeaderDelegate?.fullStretch()
      }
    }
  }
  
  var levelInfoView: LevelInfoView?
  
  private let minProgress: CGFloat = 0.01
  
  func setupWithProgressionData(data: ProgressHeaderData) {
    let botProgress = CGFloat(data.botValue) / CGFloat(data.maxBotValue)
    let topProgress = CGFloat(data.topValue) / CGFloat(data.maxTopValue)
    
    levelInfoView?.label.text = "\(data.level)"
    
    topLabel?.text = "\(data.topValue)/\(data.maxTopValue)"
    botLabel?.text = "\(data.botValue)/\(data.maxBotValue)"
    
    doubleProgressBar.topProgress = max(topProgress, minProgress)
    doubleProgressBar.botProgress = max(botProgress, minProgress)
  }
  
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
    
    if let layoutAttributes = layoutAttributes as? StratchyLayoutAttributes {
      let stratch = (layoutAttributes.deltaY / layoutAttributes.maxDelta) * 1.0
      lebelsContainer.alpha = stratch
    }
    
    bottomSpaceHeight = bottomSpaceView.bounds.height
  }
  
  
}
