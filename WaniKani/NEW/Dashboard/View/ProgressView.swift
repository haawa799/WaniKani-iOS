//
//  ProgressView.swift
//  WaniKani
//
//  Created by Andriy K. on 3/16/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit


class ProgressView: UIView {
  
  @IBOutlet weak var doubleProgressBar: DoubleProgressBar!
  private var label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let frame = doubleProgressBar.circleContentView.bounds
    label = UILabel(frame: frame)
    label.alpha = 0.5
    label.text = "9"
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = NSTextAlignment.Center
    
    //
    doubleProgressBar.circleContentView.addSubview(label)
    // Center horizontally
    var constraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[superview]-(<=1)-[label]",
      options: NSLayoutFormatOptions.AlignAllCenterX,
      metrics: nil,
      views: ["superview": doubleProgressBar.circleContentView, "label": label])
    
    doubleProgressBar.circleContentView.addConstraints(constraints)
    
    // Center vertically
    constraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:[superview]-(<=1)-[label]",
      options: NSLayoutFormatOptions.AlignAllCenterY,
      metrics: nil,
      views: ["superview": doubleProgressBar.circleContentView, "label": label])
    
    doubleProgressBar.circleContentView.addConstraints(constraints)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Fix for weird bug of iOS8 not calling layoutSubviews for subviews
    delay(0.0) { () -> () in
      if #available(iOS 9, *) {} else {
        self.doubleProgressBar.update()
      }
      var rect = self.doubleProgressBar.circleContentView.bounds
      rect = rect.centerAndAdjustPercentage(percentage: 0.5)
      self.label.adjustFontSizeToFitRect(rect)
    }
  }
  
}